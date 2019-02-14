class Card < ApplicationRecord

  belongs_to :column
  acts_as_list scope: :column

  validates_presence_of :title
end
