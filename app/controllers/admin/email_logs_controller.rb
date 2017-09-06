module Admin
  class EmailLogsController < AdminController
    def new
      @users_select = User.all.collect { |u| ["#{u.name} (#{u.email})", u.id] }
      @email_log = EmailLog.new
    end

    def create
      subject = email_logs_params[:subject]
      User.where(id: user_ids).find_each { |user| user.email_logs.create!(subject: subject) }
      flash[:notice] = "Logs updated for email with subject line - #{subject}"
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
      log_params.permit(:subject, :user_id)
    end

    def user_ids
      email_logs_params[:user_id].reject { |r| r.blank? }
    end
  end
end
