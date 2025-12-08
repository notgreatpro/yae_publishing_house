module WishlistsHelper
  def render_wishlist_button(product, show_text: true, button_class: '')
    render 'shared/wishlist_button', 
           product: product, 
           show_text: show_text, 
           button_class: button_class
  end

  def wishlist_count
    return 0 unless customer_signed_in?
    current_customer.wishlists.count
  end
end