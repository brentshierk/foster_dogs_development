module Admin
  class UsersController < AdminController
    before_action :load_filter_categories, only: :show_filters

    def index
      @active_filters = Hash.new

      query = User.subscribed.order('created_at DESC')

      if taggable_filter_params.present?
        @active_filters.merge!(taggable_filter_params)

        taggable_filter_params.each_pair do |key, values|
          query = query.tagged_with(values, in: key)
        end
      end

      if queryable_filter_params.present?
        @active_filters.merge!(queryable_filter_params)
        query = query.where(queryable_filter_params)
      end

      @all_users = query
      @paginate = @active_filters.empty? # paginate if filters aren't selected
      query = query.page(params[:page]) if @paginate
      @users = query
    end

    def search
      # TODO: clean this up
      # this is hacky, but we reload out of the elasticsearch results to hit activerecord and allow pagination
      search = User.search(params[:user_search]) if params[:user_search]
      search_uuids = search.results.map(&:uuid)
      @search_term = params[:user_search]
      @users = User.where(uuid: search_uuids).page(params[:page])
      @all_users = @users
      render 'index'
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    def show_filters
    end

    def show
      @user = User.find(params[:id])
      @note = Note.new
    end

    def download_csv
      csv = CsvService.users(users: User.all.order('created_at ASC'))
      send_data csv, filename: "foster-roster-#{Date.current}.csv"
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    private

    def queryable_filter_params
      params.permit(other_pets: [], fospice: [], fosters_cats: [], big_dogs: [])
    end

    def taggable_filter_params
      params.permit(
        :experience, :size_preferences, :activity_preferences, :schedule, # used if clicking through a url
        experience: [], size_preferences: [], activity_preferences: [], schedule: [] # used through form
      )
    end

    def load_filter_categories
      @tagged_categories = Hash.new

      # allow users to choose tags as filters
      ActsAsTaggableOn::Tagging
        .includes(:tag)
        .where(taggable_type: "User")
        .group_by(&:context).each do |k, v|
          @tagged_categories[k] = v.map { |r| r.tag.name }.compact.uniq
        end

      # other stuff
      @queryable_categories = Hash.new
      @queryable_categories[:other_pets] = ['true', 'false']
      @queryable_categories[:fospice] = ['true', 'false']
      @queryable_categories[:fosters_cats] = ['true', 'false']
      @queryable_categories[:big_dogs] = ['true', 'false']
    end
  end
end
