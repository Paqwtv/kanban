class Board < ApplicationRecord

  has_many :columns, dependent: :destroy

  validates_presence_of :uid, :title

  before_validation :create_uid, on: :create

  def to_param
    uid
  end

  private

  def create_uid
    self.uid = SecureRandom.base64(12)
  end

end
