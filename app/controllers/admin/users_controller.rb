module Admin
  class UsersController < AdminController
    before_action :load_filter_categories, only: :index

    def index
      query = User.all

      if taggable_filter_params.present?
        @active_filters = taggable_filter_params

        taggable_filter_params.each_pair do |key, values|
          query = query.tagged_with(values, in: key)
        end
      end
      @users = query.page(params[:page])
    end

    def show
      @user = User.find(params[:id])
      @note = Note.new
    end

    private

    def taggable_filter_params
      params.permit(
        :experience, :size_preferences, :activity_preferences, :schedule, # used if clicking through a url
        experience: [], size_preferences: [], activity_preferences: [], schedule: [] # used through form
      )
    end

    def load_filter_categories
      @categories = Hash.new

      ActsAsTaggableOn::Tagging
        .includes(:tag)
        .where(taggable_type: "User")
        .group_by(&:context).each do |k, v|
          @categories[k] = v.map { |r| r.tag.name }.compact.uniq
        end
    end
  end
end
