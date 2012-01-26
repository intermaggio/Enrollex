class SiteController < ApplicationController

  def index
    if request.subdomain.present?
      @organization = Organization.find_by_subdomain request.subdomain
      render 'organization' if @organization
    end
  end

end
