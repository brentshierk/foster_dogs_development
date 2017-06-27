module ApplicationHelper
  def print_status(dog, status)
    return '' unless status.present?

    string = status.status
    string += " with #{link_to(status.user.name, user_path(status.user))}" if status.user.present?
    string.html_safe
  end

  def age(dog)
    years = (Date.current - dog.birthday).to_f/(30 * 12)
    half = years.floor + 0.5
    years > half ? "#{years.floor} and a half years old" : "#{years.floor} years old"
  end

  def list_to_link(tag_type, tag_list)
    html = ""

    tag_list.each_with_index do |l, i|
      html += link_to l, users_path(tag_type => l)
      html += ", " unless i == tag_list.count - 1
    end

    html.html_safe
  end
end
