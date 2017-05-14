module ApplicationHelper
  def status(dog)
    status = dog.current_status.status
    status += " with #{link_to(dog.current_status.user.name, user_path(dog.current_status.user))}" if dog.current_status.user.present?
    status.html_safe
  end
end
