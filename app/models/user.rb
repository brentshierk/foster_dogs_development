# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  uuid              :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fostered_before   :boolean
#  fospice           :boolean
#  accepted_terms_at :datetime
#  other_pets        :boolean
#  kids              :boolean
#  address           :string
#  latitude          :float
#  longitude         :float
#  date_of_birth     :datetime
#  fostered_for      :text             default([]), is an Array
#  subscribed_at     :datetime
#  unsubscribed_at   :datetime
#  fosters_cats      :boolean
#  big_dogs          :boolean
#  phone_number      :string
#

class User < ApplicationRecord
  searchkick callbacks: :async

  paginates_per 50

  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :ensure_uuid

  has_many :notes
  has_many :survey_responses
  has_many :outreaches_users
  has_many :outreaches, through: :outreaches_users

  acts_as_taggable
  acts_as_taggable_on :experience, :schedule, :size_preferences, :activity_preferences

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
  after_commit :subscribe_to_mailchimp, on: :create

  default_scope { includes(:outreaches, :notes, :tags) }

  # TODO: maybe refactor this
  SIZE_PREFERENCES = {
    "Small" => "Up to 25 lbs.",
    "Medium" => "25-50 lbs.",
    "Large" => "50 lbs and up"
  }
  EXPERIENCE = ["Dogsat", "Fostered", "Own / Owned a dog", "Volunteered", "Other"]
  SCHEDULE = ["Almost never (0-3 hrs/day)", "4-7 hours per day", "8+ hours per day"]
  ACTIVITY_PREFERENCES = ["Low activity", "Moderately active", "Active", "Young puppy"]

  scope :subscribed, -> { where.not(subscribed_at: nil).where(unsubscribed_at: nil) }

  def to_indexed_json
    {
      uuid: uuid,
      name: name,
      email: email,
      fostered_before: fostered_before,
      fospice: fospice,
      other_pets: other_pets,
      kids: kids,
      address: address
    }.to_json
  end

  def self.size_preferences
    tag_counts_on("size_preferences").map(&:name).uniq.sort
  end

  def first_name
    name.split(' ', 2).first
  end

  def last_name
    name.split(' ', 2).last
  end

  def active?
    !subscribed_at.nil? && unsubscribed_at.nil?
  end

  def has_preference?(preference_category, preference)
    # acts_as_taggable has a weird thing with the tag name where only the first letter can be capitalized
    # Own / Owned a dog is turned to Own / owned a dog which results in a mismatch
    # downcase on both sides to sanitize before comparison
    send("#{preference_category}_list").map(&:downcase).include?(preference.downcase)
  end

  # used to translate the question slug data schema and return the taggable schema
  def question_to_preferences(question)
    data =  case question.slug.to_sym
            when :fostered_before, :fospice, :fosters_cats, :other_pets, :kids
              send(question.slug)
            when :fostered_for
              fostered_for.map { |r| ["Heavenly Angels", "Foster Dogs"].include?(r) ? "Other" : r }
            when :size
              size_preference_list.map { |r| "#{r} (#{SIZE_PREFERENCES[r]})" }
            when :experience
              experience_list.map do |r|
                if ["Own / owned a dog", "Own / owned"].include?(r)
                  "Own / Owned a dog"
                elsif r == "Never cared for an animal before"
                  "Other"
                else
                  r
                end
              end
            when :schedule
              schedule_list.map { |r| r == "Incomplete" ? "Almost never (0-3 hrs/day)" : r }
            when :activity
              activity_preference_list
            when :fosters_big_dogs
              big_dogs
            else
              raise StandardError, "Slug #{question.slug} not registered!"
            end

    validate_preferences!(answer: data, choices: question.question_choices)

    data
  end

  def validate_preferences!(answer:, choices:)
    return true if answer.nil?
    return true unless choices.present?

    verdict = if answer.is_a?(Array)
                answer.all? { |r| choices.include?(r.to_s) }
              else
                choices.include?(answer.to_s)
              end
    debugger if verdict == false
    raise 'preference does not match provided list!' unless verdict
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def subscribe_to_mailchimp
    MailchimpWorker.perform_async(id) unless subscribed_at?
  end
end
