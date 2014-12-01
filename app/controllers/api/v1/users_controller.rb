class Api::V1::UsersController < Api::ApiController
	respond_to :json

	before_action :authenticate, except: [:create, :login]

	def index
#		@users = User.all
#		respond_with @users
		respond_with @current_user, :except => [:password]
	end

  def show
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      respond_with @user, :except => [:password, :api_key, :updated_at, :created_at]
    else
      render json: "{status: Not Found}", status: :not_found
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    uploader = PhotoUploader.new(@user, :photo)
    uploader.store!(user_params[:photo])
    @user[:photo] = uploader.url

    if @user.save
      render json: @user, status: :created, :except => [:password]
      # render json: @user, status: :created, location: @user
    else
      uploader.remove!
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def search
    query_string = "%#{params[:query]}%"
   @results = User.where("first_name LIKE ? OR last_name LIKE ? OR username LIKE ?", query_string, query_string, query_string)
   respond_with @results, :except => [:password, :api_key, :updated_at, :created_at]
  end

  def login
    @user = User.userpw_login(params[:username], params[:password])
    if @user
      render json: @user, :only => :api_key
    else
      render json: '{"status":"ERROR","message":"Invalid username or password"}'
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:username, :password, :first_name, :last_name, :email, :photo, :status)
    end

end
