module Admin
  class NotesController < AdminController
    before_action :load_user

    def create
      @user.notes.create!(note_params)
      flash[:notice] = "Noted!"
      redirect_back(fallback_location: admin_user_path(@user))
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_user_path(@user))
    end

    private

    def load_user
      @user = User.find(params[:user_id])
    end

    def note_params
      params[:note].require(:note)
      params[:note].require(:author)
      params[:note].permit(:note, :author)
    end
  end
end
