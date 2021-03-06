class Thought < ActiveRecord::Base
	include SimpleHashtag::Hashtaggable
	hashtaggable_attribute :content
  has_many :simple_hashtag_hashtags
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 250 }
  default_scope -> { order(created_at: :desc) }

  def linkify
  	regex = SimpleHashtag::Hashtag::HASHTAG_REGEX
			hashtagged_content = content.to_s.gsub(regex) do
  			"<a href='##{$2}' class='hashtag' aria-controls='home' role='tab' data-toggle='tab'>#{$&}</a>"
			end
		hashtagged_content.html_safe
	end
end
