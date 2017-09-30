class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # set tags on preferences
    @user.size_preference_list = user_preference_params[:size_preferences]
    @user.activity_preference_list = user_preference_params[:activity_preferences]
    @user.schedule_list = user_preference_params[:schedule]
    @user.experience_list = user_preference_params[:experience]
    @user.accepted_terms_at = DateTime.current if user_params[:accepted_terms_at]
    @user.save!

    redirect_to thanks_users_path
  rescue => e
    # TODO: honeybadger
    flash[:alert] = "We're sorry! Something went wrong while submitting. Please try again."
    redirect_back(fallback_location: root_path)
  end

  def thanks
  end

  private

  def user_params
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
        :accepted_terms_at
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
