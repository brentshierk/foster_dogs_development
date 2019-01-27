class AdminController < ApplicationController
  before_action :authenticate_user!, :load_organization

  layout 'admin'

  private

  def load_organization
    @organization = Organization.includes(survey: [:questions, :displayable_questions]).find_by(uuid: Organization::FOSTER_DOGS_UUID)
    @survey = @organization.survey
  end
end
