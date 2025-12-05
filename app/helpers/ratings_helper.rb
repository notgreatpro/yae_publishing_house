# app/helpers/ratings_helper.rb
module RatingsHelper
  def star_rating_display(rating, size: 'medium')
    full_stars = rating.floor
    half_star = (rating % 1) >= 0.5 ? 1 : 0
    empty_stars = 5 - full_stars - half_star
    
    size_class = case size
                 when 'small' then 'rating-stars-small'
                 when 'large' then 'rating-stars-large'
                 else 'rating-stars'
                 end
    
    content_tag :span, class: size_class do
      safe_join([
        content_tag(:span, (tag.i(class: 'bi bi-star-fill') * full_stars).html_safe),
        half_star == 1 ? tag.i(class: 'bi bi-star-half') : '',
        content_tag(:span, (tag.i(class: 'bi bi-star') * empty_stars).html_safe)
      ])
    end
  end
  
  def rating_percentage(rating, total)
    return 0 if total.zero?
    ((rating.to_f / total) * 100).round(1)
  end
end