require 'rails_helper'

describe QueryService, type: :service do
  let(:organization) { FactoryBot.create(:organization) }
  let(:survey) { FactoryBot.create(:survey, organization: organization) }

  subject { QueryService.new(organization: organization) }

  context 'attrs' do
    it 'allows organization to be accessed' do
      expect(subject.instance_variable_get("@organization".to_sym)).to eq(organization)
    end
  end

  describe '#find' do
    context 'individual questions' do
      context 'multiselect' do
        context 'checking for one of a set' do
          it 'returns the user'
        end

        context 'checking for multiples' do
          it 'returns the user'
        end
      end
      context 'multiple_choice' do
        it 'returns the user'
      end

      context 'short_text' do
        it 'returns the user'
      end

      context 'long_text' do
        it 'returns the user'
      end

      context 'count' do
        it 'returns the user'
      end

      context 'boolean' do
        it 'returns the user'
      end
    end

    context 'chaining' do
    end
  end
end
