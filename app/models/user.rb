class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :email, :password
  has_many :tweets

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find{|u| u.slug == slug}
  end
end

# class User < ActiveRecord::Base
#   has_many :tweets

#   def slug
#   self.username.ljust(100).strip.gsub(/[\s\t\r\n\f]/,'-').gsub(/\W/,'-').downcase
# end

# def self.find_by_slug(slug)
#   self.find do |s|
#     s.slug == slug
#   end
# end

#   has_secure_password
# end