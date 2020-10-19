class Book < ApplicationRecord
  belongs_to :publisher
  has_and_belongs_to_many :categories

  validates :title, presence: true, uniqueness: true, length: {minimum: 1, maximum: 30}
  validates :page_count, numericality: {greater_than_or_equal_to: 1}, allow_nil: true

  scope :lengthy, -> { where("page_count > 500") }

  def as_json(options = {})
    super(
        include: {
            publisher: {only: [:name]},
            categories: {only: [:id, :name]}
        }
    )
  end

  def self.search(q)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{q}"
    response = HTTParty.get(url)
    response.parsed_response
  end
end
