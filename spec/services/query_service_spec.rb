require 'rails_helper'

describe QueryService, type: :service do
  let(:organization) { FactoryBot.create(:organization) }
  let!(:survey) { FactoryBot.create(:survey, organization: organization) }

  subject { QueryService.new(organization: organization) }

  context 'attrs' do
    it 'allows organization to be accessed' do
      expect(subject.instance_variable_get("@organization".to_sym)).to eq(organization)
    end
  end

  describe '#find' do
    let(:user) { FactoryBot.create(:user) }
    let(:control) { FactoryBot.create(:user) }

    context 'question not found' do
      let(:query_params) do
        { 'foo' => 'bar' }
      end

      it 'raises an error' do
      end
    end

    context 'individual questions' do
      context 'multiselect' do
        let!(:question) do
          FactoryBot.create(
            :question,
            survey: survey,
            question_type: Question::MULTI_SELECT,
            question_choices: ['foo', 'bar', 'baz']
          )
        end
        let!(:survey_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: user,
            response: { question.slug => ['foo', 'bar'] }
          )
        end
        let!(:control_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: control,
            response: { question.slug => ['baz'] }
          )
        end

        context 'checking for one of a set' do
          let(:query_params) do
            { question.slug => ['bar'] }
          end

          it 'returns the user' do
          end
        end

        context 'checking for multiples' do
          let(:query_params) do
            { question.slug => ['foo', 'bar'] }
          end

          it 'returns the user' do
          end
        end
      end

      context 'multiple_choice' do
        let!(:question) do
          FactoryBot.create(
            :question,
            survey: survey,
            question_type: Question::MULTIPLE_CHOICE,
            question_choices: ['foo', 'bar', 'baz']
          )
        end
        let!(:survey_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: user,
            response: { question.slug => 'foo' }
          )
        end
        let!(:control_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: control,
            response: { question.slug => 'bar' }
          )
        end
        let(:query_params) do
          { question.slug => 'foo' }
        end

        it 'returns the user' do
        end
      end

      context 'short_text' do
        it 'returns the user'
      end

      context 'long_text' do
        it 'returns the user'
      end

      context 'count' do
        let!(:question) do
          FactoryBot.create(
            :question,
            survey: survey,
            question_type: Question::COUNT
          )
        end
        let!(:survey_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: user,
            response: { question.slug => 3 }
          )
        end
        let!(:control_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: control,
            response: { question.slug => 0 }
          )
        end
        let(:query_params) do
          { question.slug => 'true' }
        end

        it 'returns the user' do
        end
      end

      context 'boolean' do
        let!(:question) do
          FactoryBot.create(
            :question,
            survey: survey,
            question_type: Question::BOOLEAN
          )
        end
        let!(:survey_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: user,
            response: { question.slug => false }
          )
        end
        let!(:control_response) do
          FactoryBot.create(
            :survey_response,
            survey: survey,
            organization: organization,
            user: control,
            response: { question.slug => true }
          )
        end
        let(:query_params) do
          { question.slug => 'false' }
        end

        it 'returns the user' do
        end
      end
    end

    context 'chaining' do
      let!(:q1) do
        FactoryBot.create(
          :question,
          survey: survey,
          question_type: Question::BOOLEAN
        )
      end
      let!(:q2) do
        FactoryBot.create(
          :question,
          survey: survey,
          question_type: Question::MULTIPLE_CHOICE,
          question_choices: ['foo', 'bar', 'baz']
        )
      end
      let!(:survey_response) do
        FactoryBot.create(
          :survey_response,
          survey: survey,
          organization: organization,
          user: user,
          response: {
            q1.slug => false,
            q2.slug => 'baz'
          }
        )
      end
      let!(:control_response) do
        FactoryBot.create(
          :survey_response,
          survey: survey,
          organization: organization,
          user: control,
          response: {
            q1.slug => true,
            q2.slug => 'foo'
          }
        )
      end
      let(:query_params) do
        {
          q1.slug => 'false',
          q2.slug => 'baz'
        }
      end

      it 'returns the user' do
      end
    end
  end
end
