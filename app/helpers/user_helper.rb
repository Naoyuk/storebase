module UserHelper
  def avatar
    if user_signed_in?
      if current_user.avatar.present?
        image_tag current_user.avatar.url, alt: 'mdo', size: '32x32', class: 'rounded-circle'
      else
        image_tag 'user.png', alt: 'mdo', size: '32x32', class: 'rounded-circle'
      end
    else
      image_tag 'user.png', alt: 'mdo', size: '32x32', class: 'rounded-circle'
    end
  end

  def account_expire_date
    t = Time.current.since(30.days)
    (Time.zone.local(t.year, t.month, t.day + 1) - 1).in_time_zone.strftime('%B %d, %Y')
  end

  def unsubscribe_or_continue
    if current_user.requested_cancel?
      link_to 'Continue Your Membership', unsubscribe_path(current_user.id), class: 'dropdown-item'
    else
      link_to 'Unsubscribe', unsubscribe_path(current_user.id), class: 'dropdown-item'
    end
  end
end
