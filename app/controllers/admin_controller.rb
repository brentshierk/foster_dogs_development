class AdminController < ApplicationController
  before_action :authenticate_user!, :load_organization

  layout 'admin'

  private

  def load_organization
    is_admin = false

    [Organization.macc, Organization.foster_dogs].each do |org|
      if current_user.has_role?(:admin, org)
        @organization = Organization.includes(survey: [:questions, :displayable_questions]).find_by(uuid: org.uuid)
        @survey = @organization.survey
        is_admin = true
      end
    end

    unless is_admin
      flash[:alert] = "You are not permitted to do this. Sorry."
      redirect_to root_path
    end
  end
end
