module ApplicationHelper
  def organization_template(slug:, type:)
    return unless File.exists?("app/views/organizations/partials/#{type}/_#{slug}.html.haml")
    render(partial: "organizations/partials/#{type}/#{slug}")
  end

  def display_question_choices(question:)
    field_name = "survey[#{question.slug}]"
    basic_params = { class: 'form-control', required: question.required }
    case question.question_type
    when Question::BOOLEAN
      select_tag field_name, options_for_select([['yes', true], ['no', false]]), basic_params.merge({ include_blank: true })
    when Question::MULTI_SELECT
      choices = ""

      question.question_choices.each do |qc|
        choices += "<div class='form-check-lable'>"
        choices += check_box_tag "#{field_name}[]", qc, false, { multiple: true, class: 'form-check-input' }
        choices += " #{qc}"
        choices += "</div>"
      end

      html = "<div class='form-check-label'>#{choices}</div>"
      html.html_safe
    when Question::COUNT
      number_field_tag field_name, nil, basic_params
    when Question::LONG_TEXT
      text_area_tag field_name, nil, basic_params
    when Question::SHORT_TEXT
      text_field_tag field_name, nil, basic_params
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

  def list_to_link(tag_type, tag_list)
    return "" unless tag_list.present?

    html = ""

    tag_list.each_with_index do |l, i|
      html += link_to l, admin_organization_users_path(organization_slug: @organization.slug, tag_type => l)
      html += ", " unless i == tag_list.count - 1
    end

    html.html_safe
  end
end
