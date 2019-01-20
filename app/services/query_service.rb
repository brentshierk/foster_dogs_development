class QueryService
  attr_reader :organization

  def initialize(organization:)
    @organization = organization
  end

  def where(query_params)
    users = User
              .joins(:survey_responses)
              .where('survey_responses.organization_id = ?', organization.id)

    query_params.each do |slug, parameters|
      question = organization.survey.questions.find_by!(slug: slug)

      case question.question_type
      when Question::MULTI_SELECT, Question::MULTIPLE_CHOICE
        users = users.where("survey_responses.response @> ?", {slug => parameters}.to_json)
      when Question::COUNT
        operator = parameters.to_s == 'true' ? '>' : '='
        users = users.where("survey_responses.response->>'#{slug}' #{operator} '0'")
      when Question::BOOLEAN
        users = users.where("survey_responses.response->>'#{slug}' = '#{parameters}'")
      end
    end

    users
  end
end
