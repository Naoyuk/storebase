class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :features, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  # 論理削除メソッド。ユーザーの退会のリクエスト日時を保存する。
  def soft_delete
    update(deleted_at: Time.current)
  end

  # ユーザーのアカウントがアクティブであることを確認する
  def active_for_authentication?
    super && !deleted_at
  end

  # キャンセルしたアカウントが30日を超えたかどうかを確認する
  def expired_account?
    active_for_authentication? && Time.current > deleted_at.since(30.days).end_of_day
  end

  # 論理削除したアカウントにメッセージを表示する
  def inactive_message
    !deleted_at ? super : :deleted_account
  end
end
