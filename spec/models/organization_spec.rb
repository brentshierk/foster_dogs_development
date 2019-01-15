# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#  published_at :datetime
#  slug         :string           not null
#

require 'rails_helper'

describe Organization, type: :model do
  describe '#ensure_slug' do
    it 'sets the slug based on name' do
      organization = Organization.create!(name: 'foo bar')
      expect(organization.slug).to eq('foo-bar')
    end

    context 'setting slug seperately' do
      it 'sets the slug' do
        organization = Organization.create!(name: 'foo bar', slug: 'baz')
        expect(organization.slug).to eq('baz')
      end
    end
  end
end
