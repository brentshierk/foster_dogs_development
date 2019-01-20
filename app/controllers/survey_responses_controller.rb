class SurveyResponsesController < ApplicationController
  before_action :load_organization

  def create
    ActiveRecord::Base.transaction do
      @user = User.find_or_initialize_by(email: user_params[:email])
      @user.attributes = user_params
      @user.accepted_terms_at = Date.current
      @user.save!
      survey = Survey.find_by(uuid: survey_params[:uuid])
      response_hash = survey_params.tap { |p| p.delete(:uuid) }
      @user.survey_responses.find_or_create_by!(survey: survey) { |response| response.response = response_hash }
    end

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
      :email,
      :phone_number,
      :address,
      :date_of_birth,
      :accepted_terms_at
    )
  end

  def survey_params
    params.require(:survey)
  end

  def load_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end
end
