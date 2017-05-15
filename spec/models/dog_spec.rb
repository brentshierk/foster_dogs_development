require 'rails_helper'

describe Dog do
  let(:dog) { FactoryGirl.build(:dog) }

  it 'ensures a status' do
    expect { dog.save! }.to change(Status, :count).by(1)
  end
end
