# == Schema Information
#
# Table name: dogs
#
#  id          :integer          not null, primary key
#  name        :string
#  short_code  :text
#  image_url   :text
#  archived_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  birthday    :date
#  urgent      :boolean          default(FALSE)
#  breed       :string
#  weight      :integer
#

require 'rails_helper'

describe Dog do
  let(:dog) { FactoryGirl.build(:dog) }

  it 'ensures a status' do
    expect { dog.save! }.to change(Status, :count).by(1)
  end
end
