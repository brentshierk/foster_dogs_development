# == Schema Information
#
# Table name: surveys
#
#  id              :integer          not null, primary key
#  uuid            :uuid
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Survey, type: :model do
  it 'belogns to an organization' do
    expect(subject).to respond_to :organization
  end

  it 'has many questions' do
    expect(subject).to respond_to :questions
  end
end
