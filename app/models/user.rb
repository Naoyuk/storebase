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

  # ユーザーが退会のリクエスト済みかどうかを確認する
  def requested_cancel?
    !!deleted_at
  end

  # キャンセルしたアカウントが30日を超えたかどうかを確認する
  def expired_account?
    Time.current > deleted_at.since(30.days).end_of_day if requested_cancel?
  end

  # 論理削除したアカウントにメッセージを表示する
  def inactive_message
    requested_cancel? ? :deleted_account : super
  end
end
