class SurveysController < ApplicationController
  before_action :load_organization_and_survey

  def show
  end

  private

  def load_organization_and_survey
    @organization = Organization.find(params[:organization_id])
    @survey = @organization.survey
  end
end
