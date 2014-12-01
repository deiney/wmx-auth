class User < ActiveRecord::Base

	has_many :friendships
	has_many :friends, :through => :friendships

	EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

#  	has_secure_password
	validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..25 }
  	validate :password, presence: true
	validates :first_name, :presence => true, :length => { :in => 3..20 }
	validates :last_name, :presence => true, :length => { :in => 3..20 }
	validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
	validates_length_of :password, :minimum => 6, :on => :create

	before_save :encrypt_password
	after_save :clear_password

	mount_uploader :photo, PhotoUploader

	before_create do |user|
	  user.api_key = user.generate_api_key
	end

	def generate_api_key
#	  loop do
	    token = SecureRandom.base64.tr('+/=', 'Qrt')
#	    break token unless User.exists?(api_key: token).any?
#	  end
	end

	def encrypt_password
		if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.password = BCrypt::Engine.hash_secret(password, self.salt)
		end
	end

	def clear_password
		self.password = nil
	end

	def self.userpw_login(login_username="", login_password="")
		user = User.find_by_username(login_username)
		if user && user.match_password(login_password)
			return user
		else
			return false
		end
	end

	def match_password(login_password="")
		password == BCrypt::Engine.hash_secret(login_password, self.salt)
	end


end
