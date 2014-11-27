class Api::V1::FriendshipsController < Api::ApiController
	respond_to :json

	before_action :authenticate

	def show
		respond_with @current_user.friends, :only => [:id, :username, :first_name, :last_name]
	end

	def create
	    if User.exists?(params[:friend_id]) and (params[:friend_id] != @current_user.id.to_s)
	    	if Friendship.where(user_id: @current_user.id, friend_id: params[:friend_id]) == []
				@friendship = @current_user.friendships.build(:friend_id => params[:friend_id])
				if @friendship.save
					# Create JSON response to new friendship
					respond_with :api, :v1, @friendship
				else
					render json: "{status: Can't add friendship}", status: :not_found
				end
			else
				render json: "{status: Friend already added}", status: :not_found
			end
		else
			render json: "{status: Friend doesn't exist}", status: :not_found
		end
	end

	def destroy
		@friendship = @current_user.friendships.find(params[:id])
		@friendship.destroy
		# respond with confirmation in JSON
	end

	def index
		# @friends = @current_user.friends
		# respond_with @friends
		respond_with @current_user.friends, :only => [:id, :username, :first_name, :last_name]
	end

end
