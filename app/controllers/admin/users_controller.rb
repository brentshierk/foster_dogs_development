module Admin
  class UsersController < AdminController
    before_action :find_user, only: [:show, :edit, :update]
    before_action :sanitize_filter_params, only: :index

    def index
      query = QueryService.new(organization: @organization).where(@active_filters)
      @all_users = query
      @users = (@paginate == true ? query.page(params[:page]) : query)
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

    def filters
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

    def sanitize_filter_params
      if params[:survey].present?
        @active_filters = params[:survey].reject { |k, v| v.empty? }
      else
        @active_filters = {}
      end

      @paginate = @active_filters.empty? # paginate if filters aren't selected
    end

    def find_user
      @user = User.includes(:outreaches).find(params[:id])
    end
  end
end
