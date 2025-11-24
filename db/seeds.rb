require 'faker'

puts "🌸 Starting Yae Publishing House Database Seeding..."
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clean existing data
puts "\n🧹 Cleaning existing data..."
OrderItem.destroy_all
Order.destroy_all
ProductAuthor.destroy_all
Product.destroy_all
Author.destroy_all
Category.destroy_all
SiteContent.destroy_all
Customer.destroy_all
Admin.destroy_all

puts "✅ Database cleaned!"

# Create Admin
puts "\n👑 Creating Admin Account..."
admin = Admin.create!(
  username: "YPHAdmin",
  email: "admin@yaepublishinghouse.com",
  full_name: "Yae Miko",
  role: "super_admin",
  password: "$TimeToRead$",
  password_confirmation: "$TimeToRead$"
)
puts "✅ Admin created: #{admin.username}"

# Create Categories
puts "\n📂 Creating Categories..."
categories = {
  light_novels: Category.create!(category_name: "Light Novels", description: "Japanese light novels and serialized stories", created_by_id: admin.id),
  manga: Category.create!(category_name: "Manga", description: "Japanese manga and comics", created_by_id: admin.id),
  graphic_novels: Category.create!(category_name: "Graphic Novels", description: "Illustrated novels and western comics", created_by_id: admin.id),
  fiction: Category.create!(category_name: "Fiction", description: "Literary fiction and contemporary novels", created_by_id: admin.id),
  non_fiction: Category.create!(category_name: "Non-Fiction", description: "History, biography, and educational books", created_by_id: admin.id),
  fantasy: Category.create!(category_name: "Fantasy", description: "Fantasy adventures and magical worlds", created_by_id: admin.id),
  sci_fi: Category.create!(category_name: "Science Fiction", description: "Futuristic and scientific fiction", created_by_id: admin.id),
  horror: Category.create!(category_name: "Horror", description: "Thriller, mystery, and horror stories", created_by_id: admin.id),
  childrens: Category.create!(category_name: "Children's Books", description: "Books for young readers", created_by_id: admin.id),
  adventure: Category.create!(category_name: "Adventure", description: "Action-packed adventure stories", created_by_id: admin.id)
}
puts "✅ #{categories.count} categories created!"

# Create Authors
puts "\n✍️  Creating Authors..."
authors = {
  # Inazuma Authors
  pursina: Author.create!(author_name: "Pursina", biography: "Author of The Saga of Hamavaran series, known for epic tales", nationality: "Inazuma", created_by_id: admin.id),
  zhenyu: Author.create!(author_name: "Zhenyu", biography: "Creator of A Legend of Sword series", nationality: "Liyue", created_by_id: admin.id),
  mr_nine: Author.create!(author_name: "Mr. Nine", biography: "Author of Flowers for Princess Fischl", nationality: "Mondstadt", created_by_id: admin.id),
  yae_miko: Author.create!(author_name: "Yae Miko", biography: "The Guuji of Grand Narukami Shrine and publisher extraordinaire", nationality: "Inazuma", created_by_id: admin.id),

  # Real World Authors - Japanese
  haruki: Author.create!(author_name: "Haruki Murakami", biography: "Contemporary Japanese writer known for surreal fiction", nationality: "Japan", created_by_id: admin.id),
  banana: Author.create!(author_name: "Banana Yoshimoto", biography: "Japanese author of Kitchen and other novels", nationality: "Japan", created_by_id: admin.id),
  natsume: Author.create!(author_name: "Natsume Soseki", biography: "Classic Japanese author of Kokoro", nationality: "Japan", created_by_id: admin.id),
  osamu: Author.create!(author_name: "Osamu Dazai", biography: "Author of No Longer Human", nationality: "Japan", created_by_id: admin.id),

  # Western Authors
  orwell: Author.create!(author_name: "George Orwell", biography: "Author of 1984 and Animal Farm", nationality: "United Kingdom", created_by_id: admin.id),
  tolkien: Author.create!(author_name: "J.R.R. Tolkien", biography: "Creator of Middle-earth and The Lord of the Rings", nationality: "United Kingdom", created_by_id: admin.id),
  king: Author.create!(author_name: "Stephen King", biography: "Master of horror and suspense", nationality: "United States", created_by_id: admin.id),
  rowling: Author.create!(author_name: "J.K. Rowling", biography: "Creator of Harry Potter series", nationality: "United Kingdom", created_by_id: admin.id)
}
puts "✅ #{Author.count} authors created!"

# Product Counter
product_count = 0

# INAZUMA BOOKS
puts "\n📚 Creating Inazuma Books..."
inazuma_books = [
  { title: "The Saga of Hamavaran Vol. 1", author: :pursina, category: :light_novels, desc: "The legendary three-volume light novel series about the adventures of Hamavaran", pages: 320, price: 16.99 },
  { title: "The Saga of Hamavaran Vol. 2", author: :pursina, category: :light_novels, desc: "Continuation of Hamavaran's epic journey through mystical lands", pages: 345, price: 16.99 },
  { title: "The Saga of Hamavaran Vol. 3", author: :pursina, category: :light_novels, desc: "The thrilling conclusion to the Hamavaran trilogy", pages: 368, price: 16.99 },
  { title: "New Chronicles of the Six Kitsune Vol. 1", author: :yae_miko, category: :light_novels, desc: "Tales of the mystical kitsune and their adventures in Inazuma", pages: 290, price: 15.99 },
  { title: "New Chronicles of the Six Kitsune Vol. 2", author: :yae_miko, category: :light_novels, desc: "More enchanting stories from the six kitsune", pages: 305, price: 15.99 },
  { title: "New Chronicles of the Six Kitsune Vol. 3", author: :yae_miko, category: :light_novels, desc: "The kitsune face new challenges in modern Inazuma", pages: 312, price: 15.99 },
  { title: "A Legend of Sword Vol. 1", author: :zhenyu, category: :adventure, desc: "Epic tale of legendary swords and their wielders", pages: 280, price: 14.99 },
  { title: "A Legend of Sword Vol. 2", author: :zhenyu, category: :adventure, desc: "The sword masters continue their journey", pages: 295, price: 14.99 },
  { title: "A Legend of Sword Vol. 3", author: :zhenyu, category: :adventure, desc: "Battles intensify as destinies collide", pages: 310, price: 14.99 },
  { title: "Pretty Please, Kitsune Guuji?", author: :yae_miko, category: :light_novels, desc: "A popular light novel about the good-for-nothing Shogun and the good-at-everything Kitsune Guuji", pages: 265, price: 13.99 },
  { title: "Shogun Almighty: Reborn as Raiden With Unlimited Power", author: :yae_miko, category: :light_novels, desc: "The strange tale of Suikou's tipsy tincture adventures", pages: 240, price: 13.99 },
  { title: "Flowers for Princess Fischl Vol. 1", author: :mr_nine, category: :fantasy, desc: "The adventures of Princess Fischl in mysterious lands", pages: 255, price: 14.99 },
  { title: "Princess Mina of the Fallen Nation Vol. 1", author: :yae_miko, category: :light_novels, desc: "A tragic tale of a princess and her fallen kingdom", pages: 300, price: 15.99 },
  { title: "Princess Mina of the Fallen Nation Vol. 2", author: :yae_miko, category: :light_novels, desc: "Princess Mina's quest for restoration", pages: 315, price: 15.99 },
  { title: "Treasured Tales of the Chouken Shinkageuchi", author: :yae_miko, category: :non_fiction, desc: "Traditional Inazuman stories and legends", pages: 280, price: 18.99 },
  { title: "Teyvat Travel Guide: Inazuma Edition", author: :yae_miko, category: :non_fiction, desc: "Complete guide to traveling through Inazuma", pages: 420, price: 22.99 },
  { title: "Inazuma Cuisine: Traditional Recipes", author: :yae_miko, category: :non_fiction, desc: "Authentic Inazuman cooking recipes and techniques", pages: 350, price: 24.99 },
  { title: "The Sacred Sakura: A History", author: :yae_miko, category: :non_fiction, desc: "Historical account of Inazuma's Sacred Sakura tree", pages: 385, price: 26.99 },
  { title: "Thunder's Eternity: The Raiden Shogun's Philosophy", author: :yae_miko, category: :non_fiction, desc: "Understanding the concept of eternity in Inazuman culture", pages: 340, price: 21.99 },
  { title: "Vision Hunt Decree: A Historical Analysis", author: :yae_miko, category: :non_fiction, desc: "Scholarly examination of Inazuma's Vision Hunt Decree period", pages: 410, price: 28.99 }
]
inazuma_books.each do |book|
  product = Product.create!(
    title: book[:title],
    isbn: Faker::Code.isbn,
    description: book[:desc],
    current_price: book[:price],
    stock_quantity: rand(20..100),
    category: categories[book[:category]],
    publisher: "Yae Publishing House",
    publication_date: Faker::Date.between(from: 3.years.ago, to: Date.today),
    pages: book[:pages],
    language: "English",
    created_by_id: admin.id
  )
  ProductAuthor.create!(product: product, author: authors[book[:author]])
  product_count += 1
  print "." if product_count % 10 == 0
end
puts "\n✅ #{inazuma_books.count} Inazuma books created!"

# REAL WORLD BOOKS
puts "\n📚 Creating Real World Books..."
real_world_books = [
  # Japanese Fiction
  { title: "Norwegian Wood", author: :haruki, category: :fiction, desc: "A nostalgic story of loss and sexuality set in 1960s Tokyo", pages: 296, price: 16.99 },
  { title: "Kafka on the Shore", author: :haruki, category: :fiction, desc: "Surreal tale of a teenage runaway and an aging simpleton", pages: 480, price: 18.99 },
  { title: "1Q84", author: :haruki, category: :fiction, desc: "Epic love story set in parallel realities", pages: 925, price: 32.99 },
  { title: "Kitchen", author: :banana, category: :fiction, desc: "Touching tale of grief, love, and the comfort of kitchens", pages: 152, price: 13.99 },
  { title: "No Longer Human", author: :osamu, category: :fiction, desc: "Haunting portrayal of alienation in modern Japan", pages: 176, price: 14.99 },
  { title: "Kokoro", author: :natsume, category: :fiction, desc: "Classic exploration of loneliness and friendship", pages: 256, price: 15.99 },
  # Fantasy
  { title: "The Hobbit", author: :tolkien, category: :fantasy, desc: "Bilbo Baggins' unexpected journey to the Lonely Mountain", pages: 310, price: 17.99 },
  { title: "The Fellowship of the Ring", author: :tolkien, category: :fantasy, desc: "The first volume of The Lord of the Rings", pages: 423, price: 19.99 },
  { title: "The Two Towers", author: :tolkien, category: :fantasy, desc: "The second volume of The Lord of the Rings", pages: 352, price: 19.99 },
  { title: "The Return of the King", author: :tolkien, category: :fantasy, desc: "The final volume of The Lord of the Rings", pages: 416, price: 19.99 },
  { title: "Harry Potter and the Philosopher's Stone", author: :rowling, category: :childrens, desc: "The boy who lived begins his magical journey", pages: 223, price: 14.99 },
  { title: "Harry Potter and the Chamber of Secrets", author: :rowling, category: :childrens, desc: "Harry's second year at Hogwarts", pages: 251, price: 14.99 },
  { title: "Harry Potter and the Prisoner of Azkaban", author: :rowling, category: :childrens, desc: "Dark secrets from the past emerge", pages: 317, price: 15.99 },
  # Horror
  { title: "The Shining", author: :king, category: :horror, desc: "Terrifying tale of isolation and madness at the Overlook Hotel", pages: 447, price: 18.99 },
  { title: "It", author: :king, category: :horror, desc: "Seven friends face their worst nightmare", pages: 1138, price: 28.99 },
  { title: "Pet Sematary", author: :king, category: :horror, desc: "Sometimes dead is better", pages: 374, price: 17.99 },
  { title: "Carrie", author: :king, category: :horror, desc: "Telekinetic revenge of a bullied teenager", pages: 199, price: 14.99 },
  # Science Fiction
  { title: "1984", author: :orwell, category: :sci_fi, desc: "Dystopian novel of totalitarian surveillance", pages: 328, price: 16.99 },
  { title: "Animal Farm", author: :orwell, category: :fiction, desc: "Allegorical novella about power and corruption", pages: 112, price: 12.99 }
]
real_world_books.each do |book|
  product = Product.create!(
    title: book[:title],
    isbn: Faker::Code.isbn,
    description: book[:desc],
    current_price: book[:price],
    stock_quantity: rand(15..80),
    category: categories[book[:category]],
    publisher: ["Yae Publishing House", "Penguin Random House", "Vintage", "Shueisha"].sample,
    publication_date: Faker::Date.between(from: 10.years.ago, to: Date.today),
    pages: book[:pages],
    language: "English",
    created_by_id: admin.id
  )
  ProductAuthor.create!(product: product, author: authors[book[:author]])
  product_count += 1
  print "." if product_count % 10 == 0
end
puts "\n✅ #{real_world_books.count} real world books created!"

# ADDITIONAL BOOKS
puts "\n📚 Creating Additional Books..."

additional_authors = []
10.times do
  additional_authors << Author.create!(
    author_name: Faker::Book.unique.author,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    nationality: ["Japan", "Inazuma", "United States", "United Kingdom"].sample,
    created_by_id: admin.id
  )
end

remaining_books_needed = 105 - product_count
remaining_books_needed.times do
  category = categories.values.sample
  author = (authors.values + additional_authors).sample

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
    language: "English",
    created_by_id: admin.id
  )
  ProductAuthor.create!(product: product, author: author)
  product_count += 1
  print "." if product_count % 10 == 0
end
puts "\n✅ Additional books created to reach #{product_count} total!"

# Create Site Content
puts "\n📄 Creating Site Content..."

SiteContent.create!(
  page_name: "about",
  content: "Welcome to Yae Publishing House, founded by the illustrious Lady Yae Miko, Guuji of the Grand Narukami Shrine. Since 1986, we have been dedicated to bringing the finest literature from Inazuma and around the world to readers everywhere. Our collection spans light novels, manga, graphic novels, fantasy, science fiction, horror, and much more - carefully curated to delight and inspire readers of all ages.",
  updated_by_id: admin.id
)

SiteContent.create!(
  page_name: "contact",
  content: "Yae Publishing House\nGrand Narukami Shrine, Inazuma City\nEmail: contact@yaepublishing.com\nPhone: +81-123-456-7890\nBusiness Hours: 9:00 AM - 6:00 PM (Inazuma Time)\n\nVisit us at the foot of Mt. Yougou, where literature and tradition meet.",
  updated_by_id: admin.id
)

puts "✅ Site content created!"

# Create Sample Customers
puts "\n👥 Creating Sample Customers..."

def random_canadian_postal_code
  letters = ('A'..'Z').to_a
  "#{letters.sample}#{rand(0..9)}#{letters.sample} #{rand(0..9)}#{letters.sample}#{rand(0..9)}"
end

def random_japanese_postal_code
  "%03d-%04d" % [rand(100..999), rand(0..9999)]
end

def random_us_postal_code
  base = "%05d" % rand(0..99999)
  rand > 0.7 ? "#{base}-#{rand(1000..9999)}" : base
end

def random_postal_code
  case rand(3)
  when 0 then random_canadian_postal_code
  when 1 then random_japanese_postal_code
  when 2 then random_us_postal_code
  end
end

5.times do |i|
  Customer.create!(
    email: "customer#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number,
    shipping_address: Faker::Address.street_address,
    city: ["Inazuma City", "Ritou", "Watatsumi Island", "Narukami Island"].sample,
    country: "Inazuma",
    postal_code: random_postal_code
  )
end

puts "✅ 5 sample customers created!"

# Summary
puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🎉 SEEDING COMPLETE!"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "\n📊 Database Summary:"
puts "  👑 Admins: #{Admin.count}"
puts "  👥 Customers: #{Customer.count}"
puts "  📂 Categories: #{Category.count}"
puts "  ✍️  Authors: #{Author.count}"
puts "  📚 Products: #{Product.count}"
puts "  🔗 Product-Author Links: #{ProductAuthor.count}"
puts "  📄 Site Content Pages: #{SiteContent.count}"
puts "\n🔐 Admin Login:"
puts "  Username: YPHAdmin"
puts "  Password: $TimeToRead$"
puts "\n✨ May the Sacred Sakura bless your publishing ventures! ✨"