# app/helpers/products_helper.rb

module ProductsHelper
  def recommendation_card(product)
    link_to product_path(product), class: 'text-decoration-none' do
      content_tag(:div, class: 'recommendation-card') do
        concat(product_image_section(product))
        concat(product_info_section(product))
      end
    end
  end

  private

  def product_image_section(product)
    content_tag(:div, class: 'recommendation-image mb-2') do
      if product.cover_image.attached?
        image_tag(product.medium_image, alt: product.title, class: 'img-fluid rounded shadow-sm')
      else
        content_tag(:div, class: 'placeholder-recommendation') do
          content_tag(:i, '', class: 'bi bi-book fs-1 text-muted')
        end
      end
    end
  end

  def product_info_section(product)
    content_tag(:div, class: 'recommendation-info') do
      concat(product_title(product))
      concat(product_author(product)) if product.authors.any?
      concat(product_rating(product)) if product.average_rating > 0
      concat(product_price(product))
    end
  end

  def product_title(product)
    content_tag(:h6, truncate(product.title, length: 50), class: 'recommendation-title text-dark mb-1')
  end

  def product_author(product)
    content_tag(:p, product.authors.first.author_name, class: 'recommendation-author text-muted small mb-2')
  end

  def product_rating(product)
    content_tag(:div, class: 'd-flex align-items-center gap-2 mb-2') do
      concat(content_tag(:div, render('shared/star_rating', rating: product.average_rating), class: 'recommendation-stars'))
      concat(content_tag(:span, "(#{product.ratings_count})", class: 'text-muted small'))
    end
  end

  def product_price(product)
    content_tag(:div, class: 'recommendation-price') do
      content_tag(:span, number_to_currency(product.current_price), class: 'text-success fw-bold fs-5')
    end
  end
end