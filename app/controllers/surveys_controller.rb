class SurveysController < ApplicationController
  before_action :load_organization_and_survey

  def show
  end

  def thanks
  end

  private

  def load_organization_and_survey
    @organization = Organization.find_by(slug: params[:organization_slug])
    @survey = @organization.survey
  end
end
