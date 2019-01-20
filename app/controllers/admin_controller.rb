class AdminController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']

  before_action :load_organization

  layout 'admin'

  private

  def load_organization
    @organization = Organization.includes(survey: [:questions, :displayable_questions]).find_by(uuid: Organization::FOSTER_DOGS_UUID)
    @survey = @organization.survey
  end
end
