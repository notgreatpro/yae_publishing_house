require 'faker'

puts "Starting Yae Publishing House Database Seeding..."
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ---------------------------------------- #
#  GLOBAL COUNTRY LIST (DIVERSE WORLDWIDE) #
# ---------------------------------------- #
COUNTRIES = [
  "Japan", "South Korea", "Philippines", "China", "Taiwan",
  "United States", "Canada", "Mexico", "Brazil", "Argentina",
  "United Kingdom", "Ireland", "France", "Germany", "Spain",
  "Italy", "Portugal", "Netherlands", "Belgium", "Sweden",
  "Norway", "Denmark", "Finland", "Poland", "Czech Republic",
  "Russia", "Turkey", "Saudi Arabia", "UAE", "India",
  "Pakistan", "Bangladesh", "Sri Lanka", "Australia",
  "New Zealand", "South Africa", "Egypt", "Kenya",
  "Nigeria", "Ghana", "Vietnam", "Thailand", "Malaysia",
  "Singapore", "Indonesia"
]

# ---------------------------------------- #
# CLEAN EXISTING DATA
# ---------------------------------------- #
puts "Clearing existing data..."

# Delete in this order:
OrderItem.destroy_all
Order.destroy_all
Customer.destroy_all
Province.destroy_all
ProductAuthor.destroy_all
Product.destroy_all
Author.destroy_all
Category.destroy_all
SiteContent.destroy_all
AdminUser.destroy_all

puts " All existing data cleared!"

# ---------------------------------------- #
# PROVINCES 
# ---------------------------------------- #
puts "\n Creating Canadian Provinces & Territories..."

provinces_data = [
  { name: 'Alberta', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'British Columbia', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'Manitoba', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'New Brunswick', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Newfoundland and Labrador', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Northwest Territories', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Nova Scotia', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Nunavut', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Ontario', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 13.0 },
  { name: 'Prince Edward Island', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Quebec', gst_rate: 5.0, pst_rate: 9.975, hst_rate: 0.0 },
  { name: 'Saskatchewan', gst_rate: 5.0, pst_rate: 6.0, hst_rate: 0.0 },
  { name: 'Yukon', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces = {}
provinces_data.each do |province_data|
  provinces[province_data[:name]] = Province.create!(province_data)
end

puts "Created #{Province.count} provinces & territories"

# ---------------------------------------- #
# ADMIN USER
# ---------------------------------------- #
puts "\n Creating Admin User for ActiveAdmin..."
admin_user = AdminUser.find_or_create_by!(username: 'YPHAdmin') do |admin|
  admin.email = 'admin@yaepublishinghouse.com'
  admin.password = '$TimeToRead$'
  admin.password_confirmation = '$TimeToRead$'
end
puts "✓ Admin User created: #{admin_user.username}"
puts "  Password: $TimeToRead$"

# ---------------------------------------- #
# CATEGORIES
# ---------------------------------------- #
puts "\n Creating Categories..."
categories = {
  light_novels: Category.create!(category_name: "Light Novels", description: "Japanese light novels and serialized stories"),
  manga: Category.create!(category_name: "Manga", description: "Japanese manga and comics"),
  graphic_novels: Category.create!(category_name: "Graphic Novels", description: "Illustrated novels and western comics"),
  fiction: Category.create!(category_name: "Fiction", description: "Literary fiction and contemporary novels"),
  non_fiction: Category.create!(category_name: "Non-Fiction", description: "History, biography, and educational books"),
  fantasy: Category.create!(category_name: "Fantasy", description: "Fantasy adventures and magical worlds"),
  sci_fi: Category.create!(category_name: "Science Fiction", description: "Futuristic and scientific fiction"),
  horror: Category.create!(category_name: "Horror", description: "Thriller, mystery, and horror stories"),
  childrens: Category.create!(category_name: "Children's Books", description: "Books for young readers"),
  adventure: Category.create!(category_name: "Adventure", description: "Action-packed adventure stories")
}
puts "#{categories.count} categories created!"

# ---------------------------------------- #
# AUTHORS (REAL + GENSHIN)
# ---------------------------------------- #
puts "\n Creating Authors..."

authors = {
  pursina: Author.create!(author_name: "Pursina", biography: "Author of The Saga of Hamavaran series", nationality: COUNTRIES.sample),
  zhenyu: Author.create!(author_name: "Zhenyu", biography: "Creator of A Legend of Sword", nationality: COUNTRIES.sample),
  mr_nine: Author.create!(author_name: "Mr. Nine", biography: "Author of Flowers for Princess Fischl", nationality: COUNTRIES.sample),
  yae_miko: Author.create!(author_name: "Yae Miko", biography: "The Guuji of Grand Narukami Shrine", nationality: COUNTRIES.sample),

  haruki: Author.create!(author_name: "Haruki Murakami", biography: "Japanese writer known for surreal fiction", nationality: COUNTRIES.sample),
  banana: Author.create!(author_name: "Banana Yoshimoto", biography: "Author of Kitchen", nationality: COUNTRIES.sample),
  natsume: Author.create!(author_name: "Natsume Soseki", biography: "Author of Kokoro", nationality: COUNTRIES.sample),
  osamu: Author.create!(author_name: "Osamu Dazai", biography: "Author of No Longer Human", nationality: COUNTRIES.sample),

  orwell: Author.create!(author_name: "George Orwell", biography: "Author of 1984", nationality: COUNTRIES.sample),
  tolkien: Author.create!(author_name: "J.R.R. Tolkien", biography: "Creator of LOTR", nationality: COUNTRIES.sample),
  king: Author.create!(author_name: "Stephen King", biography: "Master of horror", nationality: COUNTRIES.sample),
  rowling: Author.create!(author_name: "J.K. Rowling", biography: "Writer of Harry Potter", nationality: COUNTRIES.sample)
}

puts " #{Author.count} authors created!"

# ---------------------------------------- #
# PRODUCT COUNTER
# ---------------------------------------- #
product_count = 0

# ---------------------------------------- #
# INAZUMA BOOKS
# ---------------------------------------- #
puts "\n Creating Inazuma Books..."

inazuma_books = [
  { title: "The Saga of Hamavaran Vol. 1", author: :pursina, category: :light_novels, desc: "Epic Hamavaran adventures", pages: 320, price: 16.99 },
  { title: "The Saga of Hamavaran Vol. 2", author: :pursina, category: :light_novels, desc: "Continuation of Hamavaran's journey", pages: 345, price: 16.99 },
  { title: "The Saga of Hamavaran Vol. 3", author: :pursina, category: :light_novels, desc: "Final battle for Hamavaran", pages: 368, price: 16.99 },
  { title: "New Chronicles of the Six Kitsune Vol. 1", author: :yae_miko, category: :light_novels, desc: "Mystical kitsune tales", pages: 290, price: 15.99 },
  { title: "New Chronicles Vol. 2", author: :yae_miko, category: :light_novels, desc: "More adventures", pages: 305, price: 15.99 },
  { title: "New Chronicles Vol. 3", author: :yae_miko, category: :light_novels, desc: "Kitsune face new trials", pages: 312, price: 15.99 },
  { title: "A Legend of Sword Vol. 1", author: :zhenyu, category: :adventure, desc: "Swords and heroes", pages: 280, price: 14.99 },
  { title: "A Legend of Sword Vol. 2", author: :zhenyu, category: :adventure, desc: "Journeys continue", pages: 295, price: 14.99 },
  { title: "A Legend of Sword Vol. 3", author: :zhenyu, category: :adventure, desc: "Final duel", pages: 310, price: 14.99 },
  { title: "Pretty Please, Kitsune Guuji?", author: :yae_miko, category: :light_novels, desc: "Fun Inazuman comedy novel", pages: 265, price: 13.99 },
  { title: "Shogun Almighty", author: :yae_miko, category: :light_novels, desc: "Overpowered Raiden reincarnation story", pages: 240, price: 13.99 },
  { title: "Flowers for Princess Fischl Vol. 1", author: :mr_nine, category: :fantasy, desc: "Princess Fischl in the Abyss", pages: 255, price: 14.99 },
  { title: "Princess Mina Vol. 1", author: :yae_miko, category: :light_novels, desc: "Tragic princess tale", pages: 300, price: 15.99 },
  { title: "Princess Mina Vol. 2", author: :yae_miko, category: :light_novels, desc: "Kingdom rebuilds", pages: 315, price: 15.99 },
  { title: "Treasured Tales of Chouken Shinkageuchi", author: :yae_miko, category: :non_fiction, desc: "Traditional Inazuman tales", pages: 280, price: 18.99 },
  { title: "Teyvat Travel Guide: Inazuma", author: :yae_miko, category: :non_fiction, desc: "Complete Inazuma guide", pages: 420, price: 22.99 },
  { title: "Inazuma Cuisine", author: :yae_miko, category: :non_fiction, desc: "Traditional recipes", pages: 350, price: 24.99 },
  { title: "The Sacred Sakura: A History", author: :yae_miko, category: :non_fiction, desc: "History of Sacred Sakura", pages: 385, price: 26.99 },
  { title: "Thunder's Eternity", author: :yae_miko, category: :non_fiction, desc: "Shogun philosophy", pages: 340, price: 21.99 },
  { title: "Vision Hunt Decree Analysis", author: :yae_miko, category: :non_fiction, desc: "History of Vision Hunt era", pages: 410, price: 28.99 }
]

inazuma_books.each do |book|
  product = Product.create!(
    title: book[:title],
    isbn: Faker::Code.isbn,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    current_price: book[:price],
    stock_quantity: rand(20..100),
    category: categories[book[:category]],
    publisher: "Yae Publishing House",
    publication_date: Faker::Date.between(from: 3.years.ago, to: Date.today),
    pages: book[:pages],
    language: "English"
  )

  ProductAuthor.create!(product: product, author: authors[book[:author]])
  product_count += 1
end

puts " #{inazuma_books.count} Inazuma books created!"

# ---------------------------------------- #
# REAL WORLD BOOKS
# ---------------------------------------- #
puts "\n Creating Real World Books..."

real_world_books = [
  { title: "Norwegian Wood", author: :haruki, category: :fiction, desc: "Story of loss", pages: 296, price: 16.99 },
  { title: "Kafka on the Shore", author: :haruki, category: :fiction, desc: "Parallel worlds", pages: 480, price: 18.99 },
  { title: "1Q84", author: :haruki, category: :fiction, desc: "Epic love", pages: 925, price: 32.99 },
  { title: "Kitchen", author: :banana, category: :fiction, desc: "Grief & comfort", pages: 152, price: 13.99 },
  { title: "No Longer Human", author: :osamu, category: :fiction, desc: "Alienation in Japan", pages: 176, price: 14.99 },
  { title: "Kokoro", author: :natsume, category: :fiction, desc: "Loneliness & friendship", pages: 256, price: 15.99 },

  { title: "The Hobbit", author: :tolkien, category: :fantasy, desc: "Bilbo's journey", pages: 310, price: 17.99 },
  { title: "The Fellowship of the Ring", author: :tolkien, category: :fantasy, desc: "LOTR Vol.1", pages: 423, price: 19.99 },
  { title: "The Two Towers", author: :tolkien, category: :fantasy, desc: "LOTR Vol.2", pages: 352, price: 19.99 },
  { title: "The Return of the King", author: :tolkien, category: :fantasy, desc: "LOTR Vol.3", pages: 416, price: 19.99 },

  { title: "Harry Potter 1", author: :rowling, category: :childrens, desc: "The boy who lived", pages: 223, price: 14.99 },
  { title: "Harry Potter 2", author: :rowling, category: :childrens, desc: "The Chamber of Secrets", pages: 251, price: 14.99 },
  { title: "Harry Potter 3", author: :rowling, category: :childrens, desc: "Azkaban", pages: 317, price: 15.99 },

  { title: "The Shining", author: :king, category: :horror, desc: "Overlook Hotel", pages: 447, price: 18.99 },
  { title: "It", author: :king, category: :horror, desc: "Nightmare clown", pages: 1138, price: 28.99 },
  { title: "Pet Sematary", author: :king, category: :horror, desc: "Dead is better", pages: 374, price: 17.99 },
  { title: "Carrie", author: :king, category: :horror, desc: "Telekinetic revenge", pages: 199, price: 14.99 },

  { title: "1984", author: :orwell, category: :sci_fi, desc: "Dystopia", pages: 328, price: 16.99 },
  { title: "Animal Farm", author: :orwell, category: :fiction, desc: "Political allegory", pages: 112, price: 12.99 }
]

real_world_books.each do |book|
  product = Product.create!(
    title: book[:title],
    isbn: Faker::Code.isbn,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    current_price: book[:price],
    stock_quantity: rand(15..80),
    category: categories[book[:category]],
    publisher: ["Yae Publishing House", "Penguin Random House", "Vintage", "Shueisha"].sample,
    publication_date: Faker::Date.between(from: 10.years.ago, to: Date.today),
    pages: book[:pages],
    language: "English"
  )

  ProductAuthor.create!(product: product, author: authors[book[:author]])
  product_count += 1
end

puts " #{real_world_books.count} real-world books created!"

# ---------------------------------------- #
# EXTRA RANDOM AUTHORS (DIVERSE)
# ---------------------------------------- #
puts "\n Creating Additional Random Books..."

extra_authors = 10.times.map do
  Author.create!(
    author_name: Faker::Book.unique.author,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    nationality: COUNTRIES.sample
  )
end

remaining = 105 - product_count

remaining.times do
  category = categories.values.sample
  author = (authors.values + extra_authors).sample

  product = Product.create!(
    title: Faker::Book.unique.title,
    isbn: Faker::Code.isbn,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    current_price: rand(11.99..34.99).round(2),
    stock_quantity: rand(10..100),
    category: category,
    publisher: ["Yae Publishing House", "Random House", "HarperCollins", "Kodansha"].sample,
    publication_date: Faker::Date.between(from: 5.years.ago, to: Date.today),
    pages: rand(180..450),
    language: "English"
  )

  ProductAuthor.create!(product: product, author: author)
  product_count += 1
end

puts " Added #{remaining} random books (Total now #{product_count})"

# ---------------------------------------- #
# SITE CONTENT
# ---------------------------------------- #
puts "\n Creating Site Content..."

SiteContent.create!(
  page_name: "about",
  content: "Welcome to Yae Publishing House, your premier destination for light novels, manga, and literature from across Teyvat and beyond. Founded by the Guuji of Grand Narukami Shrine, we bring you the finest stories from Inazuma and the world."
)

SiteContent.create!(
  page_name: "contact",
  content: "Contact us at the Grand Narukami Shrine on Mt. Yougou, Inazuma. Email: publishing@yaehouse.com | Phone: (555) YAE-MIKO"
)

puts " Site content created!"

# ---------------------------------------- #
# CUSTOMERS
# ---------------------------------------- #
puts "\n Creating Sample Customers..."

canadian_cities = ["Toronto", "Vancouver", "Montreal", "Calgary", "Winnipeg", "Edmonton", "Regina", "Saskatoon", "Halifax", "Quebec City", "Victoria", "Kamloops", "London", "Charlottetown"]
all_provinces = Province.all.to_a

5.times do |i|
  selected_province = all_provinces.sample
  
  Customer.create!(
    email: "customer#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address_line1: Faker::Address.street_address,
    address_line2: [nil, "Apt #{rand(1..20)}", "Unit #{rand(100..999)}"].sample,
    city: canadian_cities[i],
    postal_code: "#{('A'..'Z').to_a.sample}#{rand(0..9)}#{('A'..'Z').to_a.sample} #{rand(0..9)}#{('A'..'Z').to_a.sample}#{rand(0..9)}",
    province_id: selected_province.id
  )
end

puts " 5 sample customers created with addresses!"

# ---------------------------------------- #
# FINAL SUMMARY
# ---------------------------------------- #
puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "  SEEDING COMPLETE! "
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

puts "\n Database Summary:"
puts "   AdminUsers: #{AdminUser.count}"
puts "   Provinces: #{Province.count}"
puts "   Customers: #{Customer.count}"
puts "   Categories: #{Category.count}"
puts "   Authors: #{Author.count}"
puts "   Products: #{Product.count}"
puts "   Product-Author Links: #{ProductAuthor.count}"
puts "   Site Content Pages: #{SiteContent.count}"

puts "\n Admin Login:"
puts "   URL: http://localhost:3000/admin"
puts "   Username: YPHAdmin"
puts "   Password: $TimeToRead$"

puts "\n May the Sacred Sakura bless your publishing ventures!"AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?