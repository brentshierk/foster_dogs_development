class SurveyResponsesController < ApplicationController
  before_action :load_organization

  def create
    user = User.find_or_initialize_by(email: user_params[:email])
    survey = Survey.find_by(uuid: params[:survey_uuid])
    SurveyResponseService.new(user: user, survey: survey).perform!(user_params: user_params, survey_response_params: survey_response_params)
    redirect_to thanks_organization_survey_path(organization_slug: @organization.slug)
  rescue ActiveRecord::RecordInvalid => e
    # this is a catchall since we're only validating on e-mail
    flash[:alert] = "#{e.message}. If you have any questions, please shoot us an email at roster@fosterdogsnyc.com"
    redirect_back(fallback_location: root_path)
  rescue => e
    Rollbar.error(e)
    flash[:alert] = "We're sorry! Something went wrong while submitting. Please try again."
    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.permit(
      :name,
      :last_name,
      :first_name,
      :email,
      :phone_number,
      :address,
      :date_of_birth,
      :accepted_terms_at
    )
  end

  def survey_response_params
    params.require(:survey)
  end

  def load_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end
end
