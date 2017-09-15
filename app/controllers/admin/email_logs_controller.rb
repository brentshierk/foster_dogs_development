module Admin
  class EmailLogsController < AdminController
    def new
      @users = User.where(id: params.require(:user_ids))
      @email_log = EmailLog.new
    rescue => e
      flash[:alert] = e.message
      redirect_back(fallback_location: root_path)
    end

    def create
      debugger
      User.where(id: params[:user_ids]).find_each { |user| user.email_logs.create!(email_logs_params) }

      flash[:notice] = "Logs updated for email with subject line - #{email_logs_params[:subject]}"
      redirect_to admin_users_path
    # rescue => e
    #   flash[:alert] = e.message
    #   redirect_back(fallback_location: root_path)
    #   # TODO: honeybadger
    end

    private

    def email_logs_params
      params.require(:subject)
      params.require(:user_ids)
      params.require(:organization)
      params.permit(:subject, :organization)
    end
  end
end
