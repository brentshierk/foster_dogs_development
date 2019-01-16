require 'csv'

class CsvService
  attr_reader :organization, :users

  def initialize(organization:, users:)
    @organization = organization
    @users = users
  end

  def generate_users_csv!
    CSV.generate(headers: true) do |csv|
      build_header(csv)
      build_rows(csv)
    end
  end

  private

  def build_header(csv)
    csv << columns.map { |c| c.to_s.humanize.capitalize }
  end

  def build_rows(csv)
    users.each do |u|
      row = []

      user_columns.each do |attribute|
        value = u.send(attribute)
        row << value_to_human_readable(value)
      end

      survey_columns.each do |slug|
        response = u.survey_responses.select { |sr| sr.organization == organization }.first.response.with_indifferent_access
        value = response[slug]
        row << value_to_human_readable(value)
      end

      csv << row
    end
  end

  def value_to_human_readable(value)
    if value.is_a?(TrueClass)
      'yes'
    elsif value.is_a?(FalseClass)
      'no'
    elsif value.is_a?(Time)
      value.stamp('May 20, 1989')
    elsif value.is_a?(Array)
      value.join(', ')
    else
      value
    end
  end

  def columns
    user_columns.concat(survey_columns)
  end

  def survey_columns
    organization.survey.questions.pluck(:slug)
  end

  def user_columns
    [
      :created_at,
      :first_name,
      :last_name,
      :email,
      :date_of_birth,
      :address,
    ]
  end
end
