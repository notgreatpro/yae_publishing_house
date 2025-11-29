# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def about
    @page = ContentPage.find_by(slug: 'about')
  end

  def contact
    @page = ContentPage.find_by(slug: 'contact')
  end
end