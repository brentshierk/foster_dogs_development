class Admin::OutreachesController < AdminController
  before_action :find_outreach

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end

  private

  def find_outreach
    @outreach = Outreach.includes(:users).find(params[:id])
  end

  def outreach_index_params
    params.permit(:subject, :user_id, :organization_id)
  end

  def outreach_params
  end
end
