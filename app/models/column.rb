class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates_presence_of :title

end
