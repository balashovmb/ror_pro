class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(thing)
    thing.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    if auth.info
      email = auth.info[:email]
      user = User.find_by(email: email)
    end
    if user
      user.create_authorization(auth)
    else
      user = create_user(email, auth)
      user.create_authorization(auth) if user.persisted?
    end
    user
  end

  def self.create_user(email, auth)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user.skip_confirmation! if auth.provider
    user.save
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribe_digest
    update(digest_subscription: true)
  end

  def unsubscribe_digest
    update(digest_subscription: false)
  end
end
