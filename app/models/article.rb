class Article < ActiveRecord::Base

	belongs_to :user
	has_many :comments
	
	validates :title, presence: true, uniqueness: true
	validates :body, presence: true, length: {minimum: 20}
	before_create :set_visits_count
	after_create :save_categories

	has_attached_file :cover, styles: { medium: "1280x720", thumb: "800x600" }
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

	def update_visits_count
		self.update(visits_count: self.visits_count + 1)
	end

	# Custom setter
	def categories=(value)
		@categories = value
	end

	private

	def save_categories
		#raise @categories.to_yaml
		@categories.each do |category_id|
			HasCategory.create(category_id: category_id, article_id: self.id)
		end
	end

	def set_visits_count
		self.visits_count ||= 0
	end
end
