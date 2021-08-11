class Banner < ApplicationRecord
  enum name: {post_on_social_media: "post_on_social_media", spotlight_focus: "spotlight_focus", incognito_mode: "incognito_mode", burn: "burn", add_refresh_matchlist: "add_refresh_matchlist", change_location: "change_location", save_for_later: "save_for_later", maintain_high_karma_score: "maintain_high_karma_score"}
  has_one_attached :image

  validates :name, :title, :description, presence: true
  validates_uniqueness_of :name
end
