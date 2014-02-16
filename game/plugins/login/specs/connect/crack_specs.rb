require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
      end
      
      describe :crack do
        it "should crack the arguments" do
          cmd = Command.new("connect Bob password")
          @connect.cmd = cmd
          @connect.crack!
          @connect.cmd.args.name.should eq "Bob"
          @connect.cmd.args.password.should eq "password"
        end
        
        it "should handle no args" do
          cmd = Command.new("connect")
          @connect.cmd = cmd
          @connect.crack!
          @connect.cmd.args.name.should be_nil
          @connect.cmd.args.password.should be_nil
        end
        
        it "should handle a missing password" do
          cmd = Command.new("connect Bob")
          @connect.cmd = cmd
          @connect.crack!
          @connect.cmd.args.name.should be_nil
          @connect.cmd.args.password.should be_nil
        end

        it "should accept a multi-word password" do
          cmd = Command.new("connect Bob bob's password")
          @connect.cmd = cmd
          @connect.crack!
          @connect.cmd.args.name.should eq "Bob"
          @connect.cmd.args.password.should eq "bob's password"
        end        
      end      
    end
  end
end