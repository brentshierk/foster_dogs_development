class UsersController < ApplicationController
  def index
    query = User.all

    if taggable_filter_params.present?
      taggable_filter_params.each_pair do |key, values|
        query = query.tagged_with(values, in: key)
      end
    end

    @users = query.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def taggable_filter_params
    params.permit(:size_preference, :experience, :size_preferences, :activity_preferences, :schedule)
  end
end
