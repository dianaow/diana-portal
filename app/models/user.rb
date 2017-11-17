class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true, length: {maximum: 20}
  validates :name, uniqueness: { case_sensitive: false }, if: -> { self.name.present? }
  validates_format_of :name, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_name
  acts_as_voter       
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_many :friendships
  has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id"
  
  # active friend: current user sends a request which has been accepted by other party
  has_many :active_friends, -> { where(friendships: { accepted: true}) }, through: :friendships, source: :friend
  
  # received friend: other user sends a request which has been accepted by current user
  has_many :received_friends, -> { where(friendships: { accepted: true}) }, through: :received_friendships, source: :user
  
  # pending friend: current user sends a request which has not been accepted by other party
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, through: :friendships, source: :friend
  
  # requested friendship: other user sends a request which has not been accepted by current user
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, through: :received_friendships, source: :user
  
  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'
  has_many :personal_messages, dependent: :destroy
  
  scope :all_except, ->(user) { where.not(id: user) }

  def self.top_10_most_authored 
    self.joins(:articles)
        .group("users.id")
        .select("users.id, email, name, count(articles.id) AS articles_count")
        .order("articles_count DESC")
        .limit(10)
  end
  
  def self.popular_users
    self.joins(:friendships)
        .where(friendships: {accepted: true})
        .group("users.id")
        .select("users.id, count(friendships) AS followers_count")
        .order("followers_count DESC")
  end
  

  def self.active_users
    User.where('last_sign_in_at >= ?', 1.month.ago)
  end
  

  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end
    
  def friends
    active_friends | received_friends
  end

  def pending
    pending_friends | requested_friendships
  end
  
  def self_initiated_friends
    active_friends | pending_friends
  end
  
  def follows?(new_friend)
    friendships.map(&:friend).include?(new_friend)
  end
  
  def self.search(search)
      where('name LIKE ?', "%#{search}%")
  end

  def feed
    following_ids = "SELECT friend_id FROM friendships
                     WHERE (user_id = :user_id AND accepted = 't')"
    Article.published.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:name) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def validate_name
    if User.where(email: name).exists?
      errors.add(:name, :invalid)
    end
  end


end
