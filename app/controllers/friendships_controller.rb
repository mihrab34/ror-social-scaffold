class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendship = current_user.friendships
    @requests = current_user.friend_requests
  end

  def show
    @friendship
  end

  def create
    @friendship = current_user.friendships.build(friendship_params)
    Friendship.create(user_id: current_user.id, friend_id: @friendship.id)
    return unless @friendship.save

    flash[:success] = 'Friend Request Sent'
    redirect_to users_path
  end

  def accept
    @user = User.find_by(id: params[:format])
    current_user.confirm_friend(@user)
    flash[:success] = 'Friend Request Accepted'
    redirect_to users_path
  end

  def reject
    @user = User.find_by(id: params[:format])
    current_user.cancel_request(@user)
    flash[:success] = 'Friend Request Rejected'
    redirect_to users_path
  end

  def destroy
    friend_user_id = params[:id]
    Friendship.find([current_user.id, friend_user_id]).destroy
    redirect_to users_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end
