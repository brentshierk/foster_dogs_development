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
      survey = Survey.find_by(uuid: params[:survey_uuid])
      SurveyResponseService.new(user: @user, survey: survey).perform!(user_params: user_params, survey_response_params: survey_response_params)
      flash[:notice] = "Successfully updated #{@user.name}!"
      redirect_to admin_user_path(@user)
    rescue => e
      Rollbar.error(e)
      flash[:alert] = "Something went wrong while submitting. #{e.message}"
      redirect_back(fallback_location: admin_users_path)
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

    def user_params
      params.permit(
        :name,
        :last_name,
        :first_name,
        :email,
        :phone_number,
        :address,
        :date_of_birth,
        :accepted_terms_at
      )
    end

    def survey_response_params
      params.require(:survey)
    end

    def sanitize_filter_params
      if params[:survey].present?
        @active_filters = params[:survey].reject { |k, v| v.empty? }
      else
        @active_filters = {}
      end

      @paginate = @active_filters.empty? # paginate if filters aren't selected
    end

    def find_user
      @user = User.includes(:outreaches, :survey_responses).find(params[:id])
      @survey_response = @user.survey_responses.find { |r| r.organization_id == @organization.id }
    end
  end
end
