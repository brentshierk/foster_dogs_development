module ApplicationHelper
  def print_status(dog, status)
    string = status.status
    string += " with #{link_to(status.user.name, user_path(status.user))}" if status.user.present?
    string.html_safe
  end

  def age(dog)
    years = (Date.current - dog.birthday).to_f/(30 * 12)
    half = years.floor + 0.5
    years > half ? "#{years.floor} and a half years old" : "#{years.floor} years old"
  end
end
