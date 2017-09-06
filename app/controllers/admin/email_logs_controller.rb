module Admin
  class EmailLogsController < AdminController
    def new
      @users_select = User.all.collect { |u| ["#{u.name} (#{u.email})", u.id] }
      @email_log = EmailLog.new
    end

    def create
      User.where(id: params[:email_log][:user_id]).find_each { |user| user.email_logs.create!(email_logs_params) }
      flash[:notice] = "Logs updated for email with subject line - #{email_logs_params[:subject]}"
      redirect_to admin_users_path
    rescue => e
      flash[:alert] = e.message
      redirect_back(fallback_location: root_path)
      # TODO: honeybadger
    end

    private

    def email_logs_params
      log_params = params[:email_log]
      log_params.require(:subject)
      log_params.require(:user_id)
      log_params.require(:organization)
      log_params.permit(:subject, :organization)
    end
  end
end
