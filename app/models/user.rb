require 'file_size_validator'
class User < ActiveRecord::Base
  authenticates_with_sorcery!

  before_validation(on: :create) do
    self.update_attribute(:email, "camper#{Time.now.to_i.to_s + self.parent_id.to_s}@enrollex.org") if self.utype == 'camper'
  end

  after_validation do
    self.phone.gsub!(/[^\d]/, '')
    self.phone = self.phone[1..-1] if self.phone.length > 10
  end

  after_create do
    unless self.salt || self.utype == 'camper'
      Pony.mail(
      to: self.email,
      from: 'robot@enrollex.org',
      subject: 'Enrollex invitation',
      body: "Hey there! #{self.instructing_for.last.name} has just listed you as an instructor. To complete your registration, just visit the following link: http://#{self.instructing_for.last.subname}.enrollex.org/signup?type=email&id=#{self.id}&hash=#{self.hash.abs}. Thanks!",
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: 'robot@enrollex.org',
        password: 'b0wserFire',
        authentication: :plain,
        domain: 'enrollex.org'
      }
    )
    end
  end

  serialize :ghash, Hash

  mount_uploader :image, UserImage
  validates :image, file_size: { maximum: 5.megabytes.to_i }

  has_many :campers, class_name: 'User', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id'
  has_and_belongs_to_many :admin_organizations, class_name: 'Organization', join_table: 'organizations_admins'
  has_and_belongs_to_many :instructing, class_name: 'Course', join_table: 'instructors_courses'
  has_and_belongs_to_many :instructing_for, class_name: 'Organization', join_table: 'instructors_organizations'
  has_and_belongs_to_many :courses, join_table: 'campers_courses'

  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email

  def name
    self.first_name + ' ' + self.last_name
  end
end
