# app/controllers/pages_controller.rb
# Feature 1.4 - Show pages for contact and about

class PagesController < ApplicationController
  def about
    @page = Page.find_by(slug: 'about')
    
    unless @page
      render html: '<h1>About page not found</h1><p>Please create an "About" page in the admin panel with slug "about".</p>'.html_safe, status: :not_found
    end
  end

  def contact
    @page = Page.find_by(slug: 'contact')
    
    unless @page
      render html: '<h1>Contact page not found</h1><p>Please create a "Contact" page in the admin panel with slug "contact".</p>'.html_safe, status: :not_found
    end
  end
end