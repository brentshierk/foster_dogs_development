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
end
