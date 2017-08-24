module Admin
  class EmailLogsController < AdminController
    def create
      redirect_to admin_users_path
    rescue => e
      flash[:alert] = e.message
      # TODO: honeybadger
    end

    private

    def email_logs_params
      params.require(:subject)
    end
  end
end
