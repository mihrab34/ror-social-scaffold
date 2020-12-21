class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships
    @inverted_friendships = current_user.inverted_friendships
  end

  def create
    @friendship = Friendship.new(user_id: current_user.id)
    @friendship.friend_id = params[:user_id]

    if @friendship.save
      flash[:success] = 'Friend Request Sent'
      redirect_to root_path
    else
      redirect_to root_path, alert: 'Friend Request Failed'
    end
  end

  def update
    @friendship = Friendship.find(params[:id])
    @friendship.confirmed = true

    if @friendship.save
      flash[:success] = 'Friend Request Confirmed'
      redirect_to user_path(current_user.id)
    else
      redirect_to user_path(current_user.id), alert: 'Request Not Confirmed'
    end
  end

  def destroy
    @friendship = Friendship.find_by(friend_id: current_user.id, user_id: params[:user_id])

    if @friendship.destroy
      redirect_to user_path(current_user.id), notice: 'Friend request declined'
    else
      redirect_to user_path(current_user.id)
    end
  end
end
