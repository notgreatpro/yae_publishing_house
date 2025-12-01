# app/controllers/pages_controller.rb
# Feature 1.4 - Show pages for contact, about, privacy, and terms

class PagesController < ApplicationController
  def about
    @page = Page.find_by(slug: 'about')
    render_page_or_not_found(@page, 'About')
  end

  def contact
    @page = Page.find_by(slug: 'contact')
    render_page_or_not_found(@page, 'Contact')
  end

  def privacy
    @page = Page.find_by(slug: 'privacy')
    render_page_or_not_found(@page, 'Privacy Policy')
  end

  def terms
    @page = Page.find_by(slug: 'terms')
    render_page_or_not_found(@page, 'Terms of Service')
  end

  private

  def render_page_or_not_found(page, page_name)
    unless page
      render html: "<h1>#{page_name} page not found</h1><p>Please create a \"#{page_name}\" page in the admin panel with slug \"#{page.slug rescue page_name.downcase.gsub(' ', '-')}\".</p>".html_safe, status: :not_found
    end
  end
end