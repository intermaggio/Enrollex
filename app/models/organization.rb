class Organization < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :courses
  has_and_belongs_to_many :admins, class_name: 'User', join_table: 'organizations_admins'
  has_and_belongs_to_many :users
  has_and_belongs_to_many :instructors, class_name: 'User', join_table: 'instructors_organizations'

  def self.find_by_subdomain subdomain
    Organization.where(subname: subdomain).first
  end

  before_create do
    self.subname = self.name.downcase.gsub(' ', '-').gsub(/\W/, '')
  end
end
