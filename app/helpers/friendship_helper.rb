module FriendshipHelper
  def accept_decline(request)
    render partial: 'accept_decline', locals: { request: request } if request.user.confirm_request?(current_user)
  end

  def friend_request(user)
    if current_user.friends?(user) && !current_user?(user)
      render partial: 'friend_request', locals: { user: user}
    end
  end

  def current_user?(user)
    current_user == user
  end
end
