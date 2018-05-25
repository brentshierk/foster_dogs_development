class Admin::OrganizationsController < AdminController
  before_action :find_organization

  def show
  end

  private

  def find_organization
    @organization = Organization.includes(outreaches: :users).find(params[:id])
  end
end
