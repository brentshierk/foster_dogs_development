# == Schema Information
#
# Table name: users
#
#  id    :integer          not null, primary key
#  name  :string
#  email :string
#  uuid  :uuid
#

class User < ActiveRecord::Base
  validates_uniqueness_of :uuid, :email
  validates_presence_of :name, :email, :uuid

  before_validation :ensure_uuid

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
