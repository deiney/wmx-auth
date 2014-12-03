class Api::V1::FriendshipsController < Api::ApiController
	respond_to :json

	before_action :authenticate
#	before_filter :setup_friends

	def show
		respond_with @current_user.friends, :only => [:id, :username, :first_name, :last_name]
	end

	def create
		setup_friends
		unless @friend == nil or @friend == @current_user
			Frienship.request(@current_user, @friend)
				# send a friend request
				# UserMailer.deliver_friend_request(
				# 	:user => @current_user,
				# 	:friend => @friend,
				# 	:user_url => profile_for(@current_user),
				# 	:accept_url => url_for(:action => "accept", :id => @current_user.screen_name),
				# 	:decline_url => url_for(:action => "decline", :id => @current_user.screen_name)
				# )
		end
	end

	# def create
	#     if User.exists?(params[:friend_id]) and (params[:friend_id] != @current_user.id.to_s)
	#     	if Friendship.where(user_id: @current_user.id, friend_id: params[:friend_id]) == []
	# 			@friendship = @current_user.friendships.build(:friend_id => params[:friend_id])
	# 			if @friendship.save
	# 				# Create JSON response to new friendship
	# 				respond_with :api, :v1, @friendship
	# 			else
	# 				render json: "{status: Can't add friendship}", status: :not_found
	# 			end
	# 		else
	# 			render json: "{status: Friend already added}", status: :not_found
	# 		end
	# 	else
	# 		render json: "{status: Friend doesn't exist}", status: :not_found
	# 	end
	# end

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

	def accept
		setup_friends
		if @current_user.requested_friends.include?(@friend)
			Friendship.accept(@current_user, @friend)
			respond_with '{"status":"success"}'
		else
			respond_with '{"status":"invalid friend id"}'
		end
	end

	def decline
		setup_friends
		if @current_user.requested_friends.include?(@friend)
			Friendship.breakup(@current_user, @friend)
			respond_with '{"status":"success"}'
		else
			respond_with '{"status":"invalid friend id"}'
		end
	end

	def cancel
		setup_friends
		if @current_user.pending_friends.include?(@friend)
			Friendship.breakup(@current_user, @friend)
			respond_with '{"status":"success"}'
		else
			respond_with '{"status":"invalid friend id"}'
		end
	end

	def delete
		setup_friends
		if @current_user.friends.include?(@friend)
			Friendship.breakup(@current_user, @friend)
			respond_with '{"status":"success"}'
		else
			respond_with '{"status":"invalid friend id"}'
		end
	end


	private

	def setup_friends
		@friend = User.find_by_user_id(params[:friend_id])
	end

end
