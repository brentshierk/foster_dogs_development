require 'csv'

class CsvService
  def self.users(users: [], requested_columns: [])
    CSV.generate(headers: true) do |csv|
      columns = requested_columns.present? ? requested_columns : user_columns
      validate_columns(columns)
      build_header(csv, columns)
      build_user_rows(csv, users, columns)
    end
  end

  private

  def self.build_header(csv, columns = [])
    csv << columns.map { |c| c.to_s.humanize.capitalize }
  end

  def self.build_user_rows(csv, users, columns = [])
    users.each do |u|
      row = []
      columns.each { |col| row << return_attribute_or_taggable_list(u, col) }
      csv << row
    end
  end

  def self.return_attribute_or_taggable_list(user, method)
    value = if user.respond_to?("#{method}_list")
      user.send("#{method}_list")
    else
      user.send(method)
    end

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

  def self.validate_columns(requested_columns)
    requested_columns.each { |rc| raise ArgumentError, 'columns chosen are invalid' unless user_columns.include?(rc) }
  end

  def self.user_columns
    [
      :created_at,
      :first_name,
      :last_name,
      :email,
      :date_of_birth,
      :address,
      :size_preference,
      :activity_preference,
      :experience,
      :fostered_before,
      :other_pets,
      :kids,
      :schedule,
      :fospice,
      :fosters_cats
    ]
  end
end
