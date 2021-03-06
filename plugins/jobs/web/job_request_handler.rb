module AresMUSH
  module Jobs
    class JobRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        job_admin = Jobs.can_access_jobs?(enactor)
        
        if (job.author != enactor)
          
          if (!job_admin)
            return { error: t('dispatcher.not_allowed') }
          end
        
          if (!Jobs.can_access_category?(enactor, job.category))
            return { error: t('jobs.cant_access_category') }
          end
        end
        
        Jobs.mark_read(job, enactor)
        
        
        {
          id: job.id,
          title: job.title,
          unread: job.is_unread?(enactor),
          category: job.category,
          status: job.status,
          created: job.created_date_str(enactor),
          is_open: job.is_open?,
          job_admin: job_admin,
          is_approval_job: job.author && !job.author.is_approved? && (job.author.approval_job == job),
          author: { name: job.author_name, id: job.author ? job.author.id : nil, icon: Website.icon_for_char(job.author) },
          assigned_to: job.assigned_to ? job.assigned_to.name : "--",
          description: Website.format_markdown_for_html(job.description),
          replies: Jobs.visible_replies(enactor, job).map { |r| {
            author: { name: r.author_name, icon: Website.icon_for_char(r.author) },
            message: Website.format_markdown_for_html(r.message),
            created: r.created_date_str(enactor),
            admin_only: r.admin_only
          }}
        }
      end
    end
  end
end