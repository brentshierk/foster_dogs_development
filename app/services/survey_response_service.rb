class SurveyResponseService
  def initialize(survey:, user:)
    @survey = survey
    @user = user
  end

  def perform!(user_params:, survey_response_params:)
    ActiveRecord::Base.transaction do
      @user.attributes = user_params
      @user.accepted_terms_at ||= DateTime.current
      @user.save!
      survey_response = @user.survey_responses.find_or_initialize_by(survey: @survey)
      survey_response.response = survey_response_params
      survey_response.save!
    end
  end
end
