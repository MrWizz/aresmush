module AresMUSH
  module Login
    class NoticesTemplate < ErbTemplateRenderer

      attr_accessor :char
            
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/notices.erb"
      end
      
      def mail
        @char.has_unread_mail? ? t('login.unread_mail') : t('login.no_unread_mail')
      end
      
      def alts
        AresCentral.alts(@char).select { |a| a != @char }
      end
      
      def has_alt_mail(alt)
        alt.has_unread_mail?
      end
      
      def forum
        Forum.has_unread_forum_posts?(@char) ? t('login.unread_forum') : t('login.no_unread_forum')
      end
      
      def jobs_or_requests
        return t('login.unread_requests') if @char.has_unread_requests?
        return t('login.unread_jobs') if @char.has_unread_jobs?
        return t('login.no_unread_requests')
      end
      
      def show_events
        @char.notices_events
      end
      
      def approval_notice
        Chargen.approval_job_notice(@char)
      end
      
      def events
        Events.upcoming_events
      end
      
      def start_datetime_local(event)
        event.start_datetime_local(@char)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end
      
    end
  end
end