module ApplicationHelper
  def status(dog)
    status = dog.current_status.status
    status += " with #{link_to(dog.current_status.user.name, user_path(dog.current_status.user))}" if dog.current_status.user.present?
    status.html_safe
  end

  def age(dog)
    years = (Date.current - dog.birthday).to_f/(30 * 12)
    half = years.floor + 0.5
    years > half ? "#{years.floor} and a half years old" : "#{years.floor} years old"
  end
end
