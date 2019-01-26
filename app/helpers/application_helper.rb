module ApplicationHelper
  def organization_template(slug:, type:)
    return unless File.exists?("app/views/organizations/partials/#{type}/_#{slug}.html.haml")
    render(partial: "organizations/partials/#{type}/#{slug}")
  end

  # TODO: this needs tests
  def display_question_choices(question:, filter: false, response: nil)
    field_name = "survey[#{question.slug}]"
    basic_params = { class: 'form-control', required: (filter ? false : question.required) }
    answer = existing_answer(response, question)

    case question.question_type
    when Question::BOOLEAN
      select_tag(
        field_name,
        options_for_select([['yes', true], ['no', false]], answer),
        basic_params.merge({ include_blank: true })
      )
    when Question::MULTI_SELECT
      choices = ""

      question.question_choices.each do |qc|
        checked = answer.include?(qc)
        choices += "<div class='form-check-lable'>"
        choices += check_box_tag "#{field_name}[]", qc, checked, { multiple: true, class: 'form-check-input' }
        choices += " #{qc}"
        choices += "</div>"
      end

      html = "<div class='form-check-label'>#{choices}</div>"
      html.html_safe
    when Question::MULTIPLE_CHOICE
      select_tag field_name, options_for_select(question.question_choices, answer), basic_params.merge({ include_blank: true })
    when Question::COUNT
      if filter
        select_tag field_name, options_for_select([['yes', true], ['no', false]]), basic_params.merge({ include_blank: true })
      else
        number_field_tag field_name, answer, basic_params
      end
    when Question::LONG_TEXT
      text_area_tag field_name, answer, basic_params
    when Question::SHORT_TEXT
      text_field_tag field_name, answer, basic_params
    end
  end

  def existing_answer(response, question)
    if response.present? && response[question.slug].present?
      response[question.slug]
    else
      question.question_type == Question::MULTI_SELECT ? [] : nil
    end
  end

  def users_to_printed_list(users)
    users = users.to_a
    if users.count == 1
      users.first.name
    elsif users.count == 2
      users.map(&:name).join(' and ')
    else
      last = users.pop
      users.map(&:name).join(', ') + " and #{last.name}"
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
end
