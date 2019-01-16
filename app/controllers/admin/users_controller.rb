module Admin
  class UsersController < AdminController
    before_action :load_filter_categories, only: :show_filters
    before_action :find_user, only: [:show, :edit, :update]
    before_action :load_organization

    def index
      @active_filters = Hash.new

      query = User.subscribed.order('created_at DESC').includes(:outreaches)

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
      @note = Note.new
    end

    def edit
    end

    def update
      @user.attributes = user_params

      # TODO: refactor this into a service since it looks awfully familiar to the code in UsersController#new
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
      @user.accepted_terms_at = DateTime.current if user_params[:accepted_terms_at]

      @user.save!

      flash[:notice] = 'User successfully updated'
      redirect_to edit_admin_user_path(@user.id)
    end

    def download_csv
      csv = CsvService.new(organization: @organization, users: @organization.users).generate_users_csv!
      send_data csv, filename: "#{@organization.slug}-#{Date.current}.csv"
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    private

    def load_organization
      @organization = Organization.includes(survey: [:questions], users: { survey_responses: :organization }).find_by(slug: params[:organization_slug])
    end

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

    def find_user
      @user = User.includes(:outreaches).find(params[:id])
    end

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
