module Admin
  class UsersController < AdminController
    before_action :find_user, only: [:show, :edit, :update]
    before_action :load_organization, except: [:download_csv]

    def index
      @active_filters = Hash.new

      query = User
                .subscribed
                .order('users.created_at DESC')
                .includes(:outreaches, survey_responses: [:organization])
                .where(survey_responses: { organization: @organization })
                .references(:survey_responses)

      # if taggable_filter_params.present?
      #   @active_filters.merge!(taggable_filter_params)
      #
      #   taggable_filter_params.each_pair do |key, values|
      #     query = query.tagged_with(values, in: key)
      #   end
      # end
      #
      # if queryable_filter_params.present?
      #   @active_filters.merge!(queryable_filter_params)
      #   query = query.where(queryable_filter_params)
      # end

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
      redirect_back(fallback_location: admin_organization_users_path(slug: @organization.slug))
    end

    def show_filters
    end

    def show
      @note = Note.new
    end

    def edit
    end

    def update
    end

    def download_csv
      @organization = Organization.includes(survey: :questions).find_by(slug: params[:organization_slug])
      csv = CsvService.new(organization: @organization, users: @organization.users.includes(survey_responses: :organization)).generate_users_csv!
      send_data csv, filename: "#{@organization.slug}-#{Date.current}.csv"
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_organization_users_path(slug: @organization.slug))
    end

    private

    def load_organization
      @organization = Organization.find_by(slug: params[:organization_slug])
    end

    def find_user
      @user = User.includes(:outreaches).find(params[:id])
    end
  end
end
