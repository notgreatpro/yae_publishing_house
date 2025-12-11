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
Page.destroy_all  # Add this line
AdminUser.destroy_all

puts "✓ All existing data cleared!"

# ---------------------------------------- #
# PROVINCES 
# ---------------------------------------- #
puts "\n✨ Creating Canadian Provinces & Territories..."

provinces_data = [
  { name: 'Alberta', code: 'AB', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'British Columbia', code: 'BC', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'Manitoba', code: 'MB', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'New Brunswick', code: 'NB', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Northwest Territories', code: 'NT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Nova Scotia', code: 'NS', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Nunavut', code: 'NU', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Ontario', code: 'ON', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 13.0 },
  { name: 'Prince Edward Island', code: 'PE', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Quebec', code: 'QC', gst_rate: 5.0, pst_rate: 9.975, hst_rate: 0.0 },
  { name: 'Saskatchewan', code: 'SK', gst_rate: 5.0, pst_rate: 6.0, hst_rate: 0.0 },
  { name: 'Yukon', code: 'YT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces = {}
provinces_data.each do |province_data|
  provinces[province_data[:name]] = Province.create!(province_data)
end

puts "✓ Created #{Province.count} provinces & territories"

# ---------------------------------------- #
# ADMIN USER
# ---------------------------------------- #
puts "\n✨ Creating Admin User for ActiveAdmin..."
admin_user = AdminUser.find_or_create_by!(username: 'YPHAdmin') do |admin|
  admin.email = 'admin@yaepublishinghouse.com'
  admin.password = '$TimeToRead$'
  admin.password_confirmation = '$TimeToRead$'
end
puts "✓ Admin User created: #{admin_user.username}"
puts "  Password: $TimeToRead$"

# ---------------------------------------- #
# PAGES (Feature 1.4)
# ---------------------------------------- #
puts "\n✨ Creating About and Contact Pages (Feature 1.4)..."

Page.create!(
  title: 'About Yae Publishing House',
  slug: 'about',
  content: <<~CONTENT
    "Boring. Utterly boring... Ugh, what could have possibly persuaded these people to become authors? Say, why don't you write out your story 
    and submit it to Yae Publishing House? I'm sure that would keep me amused— 
    Ahem, I'm sure it would be a best-seller." - Yae Miko, Founder of Yae Publishing House


    Welcome to Yae Publishing House, we're Inazuma's largest book publishing and bookstore since 1984. We have commited to open 7948 
    stores worldwide including Teyvat and we employ over 14 000 employees serving book lovers to enjoy its fullest.
    We have selection of numerous books and lightnovels with different authors (of course some authors from Teyvat too) to
    worked hard ensuring their products will be brought to our stores.

    Our Story

    Yae Publishing House was founded by Lady Guuji of the Grand Narukami Shrine Yae Miko who was interested on reading light novels 
    as her hobby. We first launched in 1984 with the first store opened on Inazuma City (the store was connected to our headquarters).
    Yae Publishing House was quickly becoming Inazuma's leading publishing company ensuring readers can read their favourite books.

    
    Our Mission

    Our mission is everyone deserved to read books and its very important to read to boost vocabulary and wording structure. Its our duty
    to find solutions not only our customers happy but reading our books from our authors and editors.

    
    Community Commitment

    We have a huge Yae Publishing House community across Teyvat and worldwide commited to hosting our events, collabing other companies. We thank
    you for be part of our community that its growing strong.

    Thank you for choosing Yae Publishing House. Happy reading!

  CONTENT
)

Page.create!(
  title: 'Contact Us',
  slug: 'contact',
  content: <<~CONTENT
    We'd love to hear from you! Whether you have a question about our books, need help with an order, or just want to chat about literature, we're here to help.

    Questions About Orders?

    If you have questions about a current or past order, please include your order number when contacting us. Logged-in customers can view their complete order history anytime by visiting the "My Orders" section.

    Store Inquiries

    Looking for a specific book? Want to know if we have something in stock? Interested in a particular genre or author? Our knowledgeable team is happy to help you find exactly what you're looking for.

    Event Information

    Interested in hosting an author event, book signing, or book club meeting? We love bringing authors and readers together! Contact us to discuss possibilities and availability.

    Bulk Orders & Educational Institutions

    We offer special pricing for bulk orders and work closely with schools, libraries, and educational institutions. Please reach out to discuss your specific needs.

    Publisher & Author Inquiries

    Are you an author or publisher interested in working with Yae Publishing House? We're always looking for exciting new voices and stories to share with our readers.

    Response Time

    We typically respond to all inquiries within 24 hours during business days. For urgent matters, please call us directly during business hours.
  CONTENT
)

puts "Created #{Page.count} pages (About & Contact)"
# Privacy Policy Page
Page.create!(
  title: 'Privacy Policy',
  slug: 'privacy',
  content: <<~CONTENT
    Effective Date: November 30, 2025

    Your Privacy Matters

    At Yae Publishing House, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our website and services.

    Information We Collect

    We collect information that you provide directly to us, including:
    - Name, email address, and contact information when you create an account
    - Shipping and billing addresses for order processing
    - Payment information (processed securely through our payment provider)
    - Order history and purchase preferences
    - Communications you send to us

    We also automatically collect certain information when you visit our website:
    - Browser type and device information
    - IP address and location data
    - Pages visited and time spent on our site
    - Referral sources

    How We Use Your Information

    We use your information to:
    - Process and fulfill your orders
    - Communicate with you about your orders and account
    - Send you promotional emails (you can opt out at any time)
    - Improve our website and customer service
    - Prevent fraud and enhance security
    - Comply with legal obligations

    Information Sharing

    We do not sell your personal information to third parties. We may share your information with:
    - Service providers who help us operate our business (shipping carriers, payment processors)
    - Law enforcement when required by law
    - Business partners with your explicit consent

    Data Security

    We implement industry-standard security measures to protect your information, including:
    - Encrypted data transmission (SSL/TLS)
    - Secure payment processing
    - Regular security audits
    - Restricted access to personal information

    Your Rights

    You have the right to:
    - Access the personal information we hold about you
    - Request correction of inaccurate information
    - Request deletion of your account and data
    - Opt out of marketing communications
    - Request a copy of your data

    Cookies

    We use cookies to enhance your browsing experience and analyze site traffic. You can control cookie preferences through your browser settings.

    Children's Privacy

    Our services are not directed to children under 13. We do not knowingly collect information from children under 13.

    Changes to This Policy

    We may update this Privacy Policy from time to time. We will notify you of significant changes by posting a notice on our website.

    Contact Us

    If you have questions about this Privacy Policy, please contact us at privacy@yaepublishing.com or visit our Contact page.
  CONTENT
)

# Terms of Service Page
Page.create!(
  title: 'Terms of Service',
  slug: 'terms',
  content: <<~CONTENT
    Effective Date: November 30, 2025

    Agreement to Terms

    By accessing and using Yae Publishing House's website and services, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.

    Use of Our Services

    You agree to use our services only for lawful purposes and in accordance with these Terms. You may not:
    - Use our services in any way that violates applicable laws or regulations
    - Attempt to gain unauthorized access to our systems
    - Interfere with the proper functioning of our website
    - Use automated systems to access our site without permission
    - Impersonate another person or entity

    Account Registration

    To make purchases, you must create an account. You are responsible for:
    - Maintaining the confidentiality of your account credentials
    - All activities that occur under your account
    - Notifying us immediately of any unauthorized use

    Product Information and Pricing

    We strive to provide accurate product descriptions and pricing. However:
    - Product images may differ slightly from actual items
    - Prices are subject to change without notice
    - We reserve the right to limit quantities
    - We may refuse or cancel orders at our discretion

    Orders and Payment

    By placing an order, you:
    - Agree to pay all charges at the prices in effect when you place your order
    - Authorize us to charge your payment method
    - Acknowledge that all sales are final unless otherwise stated

    Shipping and Delivery

    We ship to addresses within Canada. Shipping times vary by location and are estimates only. We are not responsible for:
    - Delays caused by shipping carriers
    - Incorrect addresses provided by customers
    - Items lost or damaged during shipping (we will work with you to resolve these issues)

    Returns and Refunds

    Please review our Return Policy for detailed information about returns and refunds. Generally:
    - Items must be returned within 30 days of delivery
    - Items must be in original, unopened condition
    - Refunds are processed within 5-10 business days
    - Shipping costs are non-refundable

    Intellectual Property

    All content on our website, including text, images, logos, and designs, is the property of Yae Publishing House or our licensors. You may not:
    - Reproduce, distribute, or modify our content without permission
    - Use our trademarks without authorization
    - Copy or scrape our website content

    Limitation of Liability

    To the fullest extent permitted by law:
    - We are not liable for indirect, incidental, or consequential damages
    - Our total liability is limited to the amount you paid for the product or service
    - We do not guarantee uninterrupted or error-free service

    Indemnification

    You agree to indemnify and hold harmless Yae Publishing House from any claims, damages, or expenses arising from your use of our services or violation of these Terms.

    Dispute Resolution

    Any disputes will be resolved through:
    - Good faith negotiations
    - Binding arbitration if negotiations fail
    - Courts in Manitoba, Canada (if arbitration is not applicable)

    Governing Law

    These Terms are governed by the laws of Manitoba, Canada, without regard to conflict of law principles.

    Changes to Terms

    We reserve the right to modify these Terms at any time. Continued use of our services after changes constitutes acceptance of the modified Terms.

    Contact Information

    For questions about these Terms of Service, please contact us at legal@yaepublishing.com or visit our Contact page.

    Severability

    If any provision of these Terms is found to be unenforceable, the remaining provisions will continue in full force and effect.
  CONTENT
)

puts "Created Privacy Policy and Terms of Service pages"
puts "  - Pages are editable at /admin/pages"

# ---------------------------------------- #
# CATEGORIES
# ---------------------------------------- #
puts "\n✨ Creating Categories..."
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

# Creating jobs
puts "✨ Creating sample jobs..."

jobs_data = [
  {
    title: "Senior Content Editor",
    department: "editorial",
    job_type: "full_time",
    location: "inazuma",
    experience_level: "senior",
    description: "We're seeking an experienced editor to lead our fiction editorial team at Yae Publishing House. You'll work with talented authors to bring their stories to life, ensuring our publications maintain the highest literary standards. This role offers the opportunity to shape the future of publishing in Inazuma.",
    responsibilities: "- Lead editorial team meetings and workflow planning\n- Review and edit manuscripts for content, style, and clarity\n- Work closely with authors through the revision process\n- Mentor junior editors and provide feedback\n- Coordinate with design and marketing teams\n- Manage editorial calendar and deadlines\n- Participate in acquisition decisions",
    requirements: "- 7+ years of editorial experience in publishing\n- Bachelor's degree in English, Literature, or related field\n- Exceptional editing and proofreading skills\n- Strong communication and interpersonal abilities\n- Experience managing editorial teams\n- Knowledge of publishing industry trends\n- Proficiency with editorial management software",
    preferred_qualifications: "- Master's degree in English or Creative Writing\n- Experience with light novels or fantasy fiction\n- Background in digital publishing\n- Multilingual abilities (Japanese preferred)\n- Published author or editor credits",
    benefits: "- Competitive salary with performance bonuses\n- Comprehensive health and dental insurance\n- Professional development budget ($2,000/year)\n- Flexible work arrangements\n- 4 weeks paid vacation\n- Book allowance and employee discounts\n- Creative workspace in our Inazuma City office",
    salary_min: 70000,
    salary_max: 95000,
    contact_email: "editorial@yaepublishing.com",
    active: true,
    featured: true
  },
  {
    title: "Marketing Coordinator",
    department: "marketing",
    job_type: "full_time",
    location: "remote",
    experience_level: "mid",
    description: "Join our dynamic marketing team to promote exciting new releases and engage our passionate reading community. As a Marketing Coordinator, you'll develop creative campaigns that bring our authors' stories to readers worldwide. This is a fully remote position with occasional travel for book tours and conventions.",
    responsibilities: "- Develop and execute marketing campaigns for book launches\n- Manage social media presence across multiple platforms\n- Coordinate author events, signings, and virtual book tours\n- Create engaging content for newsletters and blog posts\n- Analyze campaign performance and adjust strategies\n- Build relationships with book bloggers and influencers\n- Assist with press releases and media outreach",
    requirements: "- 3-5 years of marketing experience, preferably in publishing\n- Strong written and verbal communication skills\n- Social media marketing expertise\n- Proficiency with marketing analytics tools\n- Creative thinking and problem-solving abilities\n- Ability to work independently in remote environment\n- Experience with email marketing platforms",
    preferred_qualifications: "- Bachelor's degree in Marketing, Communications, or related field\n- Experience with book marketing or literary promotion\n- Graphic design skills (Adobe Creative Suite)\n- Knowledge of the book community and literary trends\n- Event planning experience",
    benefits: "- Competitive salary\n- Work from anywhere\n- Health insurance stipend\n- Professional development opportunities\n- Flexible schedule\n- Generous PTO policy\n- Company retreats and team events",
    salary_min: 55000,
    salary_max: 75000,
    contact_email: "marketing@yaepublishing.com",
    active: true,
    featured: false
  },
  {
    title: "Graphic Designer",
    department: "design",
    job_type: "full_time",
    location: "hybrid",
    experience_level: "mid",
    description: "Create stunning book covers and marketing materials that capture readers' imaginations. As our Graphic Designer, you'll be responsible for the visual identity of our publications, working closely with editors and authors to bring stories to life through compelling design. This hybrid position offers flexibility with 3 days in-office and 2 days remote.",
    responsibilities: "- Design eye-catching book covers and spine art\n- Create promotional graphics for social media and advertising\n- Develop marketing materials (posters, bookmarks, banners)\n- Maintain brand consistency across all visual assets\n- Collaborate with editorial team on layout and typography\n- Prepare files for print production\n- Stay current with design trends in publishing",
    requirements: "- 4+ years of professional design experience\n- Expert proficiency in Adobe Creative Suite (Photoshop, Illustrator, InDesign)\n- Strong portfolio demonstrating book design work\n- Understanding of print production processes\n- Typography expertise\n- Ability to work on multiple projects simultaneously\n- Strong communication and collaboration skills",
    preferred_qualifications: "- Bachelor's degree in Graphic Design or Visual Arts\n- Experience specifically with book cover design\n- Illustration skills\n- Knowledge of digital publishing formats\n- Photography or photo editing skills",
    benefits: "- Competitive salary package\n- Hybrid work model (3 days office, 2 remote)\n- Full health and dental coverage\n- Creative software subscriptions provided\n- Professional development workshops\n- Beautiful studio workspace\n- Employee book discounts",
    salary_min: 60000,
    salary_max: 80000,
    contact_email: "design@yaepublishing.com",
    active: true,
    featured: false
  },
  {
    title: "Sales Representative",
    department: "sales",
    job_type: "full_time",
    location: "inazuma",
    experience_level: "mid",
    description: "Drive book sales and build relationships with retailers, libraries, and educational institutions. As a Sales Representative, you'll be the face of Yae Publishing House to our partners, helping connect our amazing stories with readers across Teyvat. Perfect for someone who loves books and excels at relationship building.",
    responsibilities: "- Develop and maintain relationships with bookstores and retailers\n- Present new titles and secure placement orders\n- Negotiate terms and close sales deals\n- Attend trade shows and industry events\n- Monitor market trends and competitor activities\n- Provide sales forecasts and reports\n- Collaborate with marketing on promotional strategies",
    requirements: "- 3-5 years of sales experience (publishing preferred)\n- Proven track record of meeting sales targets\n- Excellent presentation and negotiation skills\n- Strong relationship-building abilities\n- Knowledge of the book retail landscape\n- Willingness to travel within region\n- CRM software experience",
    preferred_qualifications: "- Existing relationships with book retailers\n- Experience with institutional sales (libraries, schools)\n- Bachelor's degree in Business or related field\n- Passion for reading and literature\n- Familiarity with publishing industry standards",
    benefits: "- Base salary plus commission structure\n- Performance bonuses\n- Health and dental insurance\n- Company vehicle or travel allowance\n- Professional development support\n- Flexible schedule around client needs\n- Generous book allowance",
    salary_min: 50000,
    salary_max: 75000,
    contact_email: "sales@yaepublishing.com",
    active: true,
    featured: false
  },
  {
    title: "Editorial Intern",
    department: "editorial",
    job_type: "internship",
    location: "hybrid",
    experience_level: "entry",
    description: "Launch your publishing career with a hands-on internship at Yae Publishing House! You'll gain real-world experience in editorial processes, work with professional editors, and contribute to bringing exciting new stories to readers. This 6-month internship offers mentorship and potential for full-time hire.",
    responsibilities: "- Assist editors with manuscript reviews and proofreading\n- Conduct preliminary reads of submission materials\n- Research market trends and competitive titles\n- Help maintain editorial databases and tracking systems\n- Participate in editorial meetings\n- Support book launch preparations\n- Assist with author communications",
    requirements: "- Currently pursuing or recently completed degree in English, Literature, or related field\n- Strong writing and editing skills\n- Attention to detail and organizational abilities\n- Passion for reading and storytelling\n- Ability to meet deadlines\n- Proficiency in Microsoft Office\n- Availability for 20-30 hours per week",
    preferred_qualifications: "- Previous internship or volunteer experience in publishing\n- Knowledge of submission and manuscript review processes\n- Familiarity with editorial style guides\n- Active book blogger or reader community participant\n- Creative writing experience",
    benefits: "- Paid internship with competitive hourly rate\n- Flexible hybrid schedule\n- Mentorship from senior editors\n- Professional development workshops\n- Networking opportunities with industry professionals\n- Letter of recommendation upon completion\n- Potential for full-time employment",
    salary_min: 18,
    salary_max: 22,
    contact_email: "internships@yaepublishing.com",
    active: true,
    featured: true
  }
]

jobs_data.each do |job_attrs|
  Job.create!(job_attrs)
end

# ---------------------------------------- #
# AUTHORS (REAL + GENSHIN)
# ---------------------------------------- #
puts "\nCreating Authors..."

authors = {
  pursina: Author.create!(author_name: "Pursina", biography: "Author of The Saga of Hamavaran series", nationality: COUNTRIES.sample),
  zhenyu: Author.create!(author_name: "Zhenyu", biography: "Creator of A Legend of Sword", nationality: COUNTRIES.sample),
  mr_nine: Author.create!(author_name: "Mr. Nine", biography: "Author of Flowers for Princess Fischl", nationality: COUNTRIES.sample),
  yae_miko: Author.create!(author_name: "Yae Miko", biography: "The Guuji of Grand Narukami Shrine", nationality: COUNTRIES.sample),

  haruki: Author.create!(author_name: "Haruki Murakami", biography: "Japanese writer known for surreal fiction", nationality: "Japan"),
  banana: Author.create!(author_name: "Banana Yoshimoto", biography: "Author of Kitchen", nationality: "Japan"),
  natsume: Author.create!(author_name: "Natsume Soseki", biography: "Author of Kokoro", nationality: "Japan"),
  osamu: Author.create!(author_name: "Osamu Dazai", biography: "Author of No Longer Human", nationality: "Japan"),

  orwell: Author.create!(author_name: "George Orwell", biography: "Author of 1984", nationality: "United Kingdom"),
  tolkien: Author.create!(author_name: "J.R.R. Tolkien", biography: "Creator of LOTR", nationality: "United Kingdom"),
  king: Author.create!(author_name: "Stephen King", biography: "Master of horror", nationality: "United States"),
  rowling: Author.create!(author_name: "J.K. Rowling", biography: "Writer of Harry Potter", nationality: "United Kingdom")
}

puts "#{Author.count} authors created!"

# ---------------------------------------- #
# PRODUCT COUNTER
# ---------------------------------------- #
product_count = 0

# ---------------------------------------- #
# INAZUMA BOOKS
# ---------------------------------------- #
puts "\nCreating Inazuma Books..."

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

puts "✓ #{inazuma_books.count} Inazuma books created!"

# ---------------------------------------- #
# REAL WORLD BOOKS
# ---------------------------------------- #
puts "\nCreating Real World Books..."

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

puts "#{real_world_books.count} real-world books created!"

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

puts "✓ Added #{remaining} random books (Total now #{product_count})"

# ---------------------------------------- #
# CUSTOMERS
# ---------------------------------------- #
puts "\nCreating Sample Customers..."

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

puts "5 sample customers created with addresses!"

# ---------------------------------------- #
# FINAL SUMMARY
# ---------------------------------------- #
puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "SEEDING COMPLETE! "
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

puts "\n Database Summary:"
puts "   AdminUsers: #{AdminUser.count}"
puts "   Pages: #{Page.count} (About & Contact)"
puts "   Provinces: #{Province.count}"
puts "   Customers: #{Customer.count}"
puts "   Categories: #{Category.count}"
puts "   Authors: #{Author.count}"
puts "   Products: #{Product.count}"
puts "   Product-Author Links: #{ProductAuthor.count}"

puts "\n Admin Login:"
puts "   URL: http://localhost:3000/admin"
puts "   Username: YPHAdmin"
puts "   Password: $TimeToRead$"

puts "\n Edit Pages:"
puts "   URL: http://localhost:3000/admin/pages"
puts "   - About page (slug: 'about')"
puts "   - Contact page (slug: 'contact')"

puts "\n Public Pages:"
puts "   About: http://localhost:3000/about"
puts "   Contact: http://localhost:3000/contact"

puts "✓ Created #{Job.count} sample jobs!"
puts "  - #{Job.active_jobs.count} active positions"
puts "  - #{Job.featured_jobs.count} featured positions"

puts "\nMay the Sacred Sakura bless your publishing ventures!"