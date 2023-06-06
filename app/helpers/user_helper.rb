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
end

