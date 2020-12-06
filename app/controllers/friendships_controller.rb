class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships
    @requests = current_user.friend_requests
  end

  def create
    @user = User.find(params[:user_id])
    @friendship = current_user.friend_sent.build(friend_id: params[:user_id])
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

  def destroy
    if params[:id]
      Friendship.find(params[:id]).destroy
    elsif @friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id])
      @friendship.present?
      @friendship.destroy_friendship
    end
    redirect_back(fallback_location: root_path, alert: 'Friend request declined')
  end

  # private

  # def friendship_params
    # params.require(:friendship).permit(:user_id, :friend_id)
  # end
end
