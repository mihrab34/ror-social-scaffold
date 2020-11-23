module FriendshipHelper
  def accept_friendship(user)
    button_to('Accept', accept_request_path(user), method: :put, class: 'btn btn-info')
  end

  def reject_friendship(user)
    button_to('Decline', delete_request_path(user), method: :delete, class: 'btn btn-danger')
  end
end
