class User < ActiveRecord::Base

	has_many :friendships
	has_many :friends, :through => :friendships

	EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

#  	has_secure_password
	validates :username, :presence => true, :uniqueness => true
  	validate :password, presence: true
	validates :first_name, :presence => true, :length => { :in => 3..20 }
	validates :last_name, :presence => true, :length => { :in => 3..20 }
	validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX

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

end
