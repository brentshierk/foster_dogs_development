module ApplicationHelper
  def organization_template(slug:, type:)
    return unless File.exists?("app/views/organizations/partials/#{type}/_#{slug}.html.haml")
    render(partial: "organizations/partials/#{type}/#{slug}")
  end

  def display_question_choices(question:)
    case question.question_type
    when Question::BOOLEAN
      select_tag question.slug.to_sym, options_for_select([['yes', true], ['no', false]]), { include_blank: true, class: 'form-control', required: question.required }
    when Question::MULTI_SELECT
      choices = ""

      question.question_choices.each do |qc|
        choices += "<div class='form-check-lable'>"
        choices += check_box_tag question.slug.to_sym, qc, false, { multiple: true, class: 'form-check-input' }
        choices += " #{qc}"
        choices += "</div>"
      end

      html = "<div class='form-check-label'>#{choices}</div>"
      html.html_safe
    when Question::COUNT
      text_field_tag question.slug.to_sym, nil, { class: 'form-control', required: question.required }
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

  def print_status(dog, status)
    return '' unless status.present?

    string = status.status
    string += " with #{link_to(status.user.name, admin_user_path(status.user))}" if status.user.present?
    string.html_safe
  end

  def age(dog)
    years = (Date.current - dog.birthday).to_f/(30 * 12)
    half = years.floor + 0.5
    years > half ? "#{years.floor} and a half years old" : "#{years.floor} years old"
  end

  def bool_to_affirmative(string)
    case string.to_s
    when 'true', 'True'
      'yes'
    when 'false', 'False'
      'no'
    else
      'n/a'
    end
  end

  def list_to_link(tag_type, tag_list)
    return "" unless tag_list.present?

    html = ""

    tag_list.each_with_index do |l, i|
      html += link_to l, admin_users_path(tag_type => l)
      html += ", " unless i == tag_list.count - 1
    end

    html.html_safe
  end
end
