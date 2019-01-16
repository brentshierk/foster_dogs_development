module Admin
  class UsersController < AdminController
    before_action :find_user, only: [:show, :edit, :update]

    def index
      @active_filters = Hash.new

      query = User.for_index_page

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
      @users =  User.for_index_page.search(params[:user_search], page: params[:page])
      @search_term = params[:user_search]
      @paginate = true
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
      @survey_response = @user.survey_responses.includes(survey: :questions).find_by(organization: @organization)
      @note = Note.new
    end

    def edit
    end

    def update
    end

    def download_csv
      @users = @organization.users.includes(survey_responses: :organization)

      csv = CsvService.new(organization: @organization, users: @users).generate_users_csv!

      send_data csv, filename: "#{@organization.slug}-#{Date.current}.csv"
    rescue => e
      Rollbar.error(e)
      flash[:alert] = e.message
      redirect_back(fallback_location: admin_users_path)
    end

    private


    def find_user
      @user = User.includes(:outreaches).find(params[:id])
    end
  end
end
