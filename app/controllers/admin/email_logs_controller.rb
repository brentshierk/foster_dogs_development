module Admin
  class EmailLogsController < AdminController
    before_action :require_users

    def new
      @users = User.where(id: params.require(:user_ids))
      @email_log = EmailLog.new
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    def create
      User.where(id: params[:user_ids]).find_each { |user| user.email_logs.create!(email_logs_params) }

      flash[:notice] = "Logs updated for email with subject line - #{email_logs_params[:subject]}"
      redirect_to admin_users_path
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    private

    def require_users
      unless params[:user_ids].present?
        flash[:alert] = "Please pick users you would like to contact first!"
        redirect_back(fallback_location: admin_users_path)
      end
    end

    def email_logs_params
      params.require(:subject)
      params.require(:user_ids)
      params.require(:organization)
      params.permit(:subject, :organization)
    end
  end
end
