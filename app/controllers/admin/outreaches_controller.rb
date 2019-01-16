class Admin::OutreachesController < AdminController
  before_action :find_outreach, only: [:show, :destroy]
  before_action :require_users, only: [:new, :build, :create]

  def index
    @outreaches = Outreach.order('created_at DESC').includes(:users, :organization)
  rescue => e
    Rollbar.error(e)
    flash[:alert] = e.message
    redirect_back(fallback_location: admin_users_path)
  end

  def show
  end

  # hack to fix 414 html error
  def build
    @users = User.where(id: params[:user_ids])
    @outreach = Outreach.new
    render :new
  rescue => e
    Rollbar.error(e)
    flash[:alert] = e.message
    redirect_back(fallback_location: admin_users_path)
  end

  def new
    @users = User.where(id: params[:user_ids])
    @outreach = Outreach.new
  rescue => e
    Rollbar.error(e)
    flash[:alert] = e.message
    redirect_back(fallback_location: admin_users_path)
  end

  def create
    users = User.where(id: params[:user_ids])
    outreach = Outreach.new(outreach_params)
    outreach.users = users
    outreach.save!

    flash[:notice] = "Outreach sent with subject - #{outreach.subject}"
    redirect_to admin_users_path
  rescue => e
    Rollbar.error(e)
    flash[:alert] = e.message
    redirect_back(fallback_location: admin_users_path)
  end

  def destroy
    user = User.find(params[:user_id])
    @outreach.users.delete(user)
    @outreach.save!

    flash[:notice] = "Successfully deleted outreach from user"
    redirect_to admin_user_path(user.id)
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

  def find_outreach
    @outreach = Outreach.includes(:users).find(params[:id])
  end

  def outreach_params
    params.require(:subject)
    params.require(:user_ids)
    params.permit(:subject, :organization_id)
  end
end
