class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create_old
    @user = User.new(old_user_params)

    # parse date, because i'm lazy
    month = params[:user]["date_of_birth(2i)"].to_i
    day = params[:user]["date_of_birth(3i)"].to_i
    year = params[:user]["date_of_birth(1i)"].to_i
    @user.date_of_birth = Date.new(year, month, day)

    # set tags on preferences
    @user.size_preference_list = user_preference_params[:size_preferences]
    @user.activity_preference_list = user_preference_params[:activity_preferences]
    @user.schedule_list = user_preference_params[:schedule]
    @user.experience_list = user_preference_params[:experience]
    @user.accepted_terms_at = DateTime.current if old_user_params[:accepted_terms_at]

    @user.save!

    redirect_to thanks_users_path
  rescue ActiveRecord::RecordInvalid => e
    # this is a catchall since we're only validating on e-mail
    flash[:alert] = "#{e.message}. If you have any questions, please shoot us an email at roster@fosterdogsnyc.com"
    redirect_back(fallback_location: root_path)
  rescue => e
    Rollbar.error(e)
    flash[:alert] = "We're sorry! Something went wrong while submitting. Please try again."
    redirect_back(fallback_location: root_path)
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      @user.accepted_terms_at = Date.current
      @user.save!
      survey = Survey.find_by(uuid: survey_params[:uuid])
      response_hash = survey_params.tap { |p| p.delete(:uuid) }
      @user.survey_responses.find_or_create_by!(survey: survey) { |response| response.response = response_hash }
      redirect_to thanks_users_path
    end
  rescue ActiveRecord::RecordInvalid => e
    # this is a catchall since we're only validating on e-mail
    flash[:alert] = "#{e.message}. If you have any questions, please shoot us an email at roster@fosterdogsnyc.com"
    redirect_back(fallback_location: root_path)
  rescue => e
    Rollbar.error(e)
    flash[:alert] = "We're sorry! Something went wrong while submitting. Please try again."
    redirect_back(fallback_location: root_path)
  end

  def thanks
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :phone_number,
      :address,
      :date_of_birth,
      :accepted_terms_at
    )
  end

  def survey_params
    params.require(:survey)
  end

  def old_user_params
    params.
      require(:user).
      permit(
        :name,
        :email,
        :address,
        :fostered_before,
        :fospice,
        :other_pets,
        :kids,
        :accepted_terms_at,
        :fosters_cats,
        :big_dogs,
        fostered_for: []
      )
  end

  def user_preference_params
    params.
      require(:user).
      permit(
        size_preferences: [],
        experience: [],
        activity_preferences: [],
        schedule: []
      )
  end
end
