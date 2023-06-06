module UserHelper
  def avatar
    unless current_user.avatar.nil?
      image_tag current_user.avatar.url, alt: 'mdo', size: '32x32', class: 'rounded-circle'
    else
      image_tag 'user.png', alt: 'mdo', size: '32x32', class: 'rounded-circle'
    end
  end
end

