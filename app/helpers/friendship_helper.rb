module FriendshipHelper
  def accept_btn(user)
    button_to('Accept', accept_path(user), method: :patch, class: 'btn btn-secondary')
  end

  def reject_btn(user)
    button_to('Decline', reject_path(user), method: :delete, class: 'btn btn-danger')
  end

  def show_friend_btn(id = nil)
    params[:index_id] = id if id
    @viewed_user = User.find(params[:index_id] ||= params[:id])

    if current_user.pending_friend?(@viewed_user)
      link_to('Accept Friend Request', friendships_path)
    elsif @viewed_user.pending_friend?(current_user)
      link_to(
        'Decline Friend request',
        reject_path(user_id: current_user, friend_id: params[:index_id] ||= params[:id]),
        method: :delete
      )
    elsif !current_user.pending_friend?(@viewed_user)
      friend_notfriend_btn
    end
  end

  def friend_notfriend_btn
    if current_user.friend?(@viewed_user)
      link_to(
        'Cancel friendship',
        reject_path(
          user_id: current_user,
          friend_id: params[:index_id] ||= params[:id]
        ),
        method: :delete
      )
    else
      link_to(
        'Send friend request',
        user_friendships_path(
          user_id: current_user,
          friend_id: params[:index_id] ||= params[:id]
        ),
        method: :post
      )
    end
  end
end
