class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships
    @requests = current_user.friend_requests
  end

  def create
    @user = User.find(params[:user_id])
    @friendship = current_user.friendships.build(friend_id: params[:user_id])
    if @friendship.save
      flash[:success] = 'Friend Request Sent!'
    else
      flash[:danger] = 'Friend Request Failed!'
    end
    redirect_back(fallback_location: root_path)
  end

  def accept
    @user = User.find_by(id: params[:format])
    current_user.confirm_friend(@user)
    flash[:success] = 'Friend Request Accepted'
    redirect_to users_path
  end

  def decline
    @friendship = Friendship.find_by(user_id: params[:user_id], 
                  friend_id: current_user.id, confirmed: false)
    return unless @friendship

    @friendship&.destroy
    flash[:success] = 'Friend Request Declined!'
    redirect_back(fallback_location: root_path)
  end
end

  # def destroy
  #   if params[:id]
  #     Friendship.find(params[:id]).destroy
  #   else
  #     @friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id])
  #     @friendship.present?
  #     @friendship&.destroy
  #   end
  #   redirect_back(fallback_location: root_path, alert: 'Friend request declined')
  # end