class Admin::OutreachesController < AdminController
  before_action :find_outreach

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
end
