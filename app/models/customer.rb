class Customer < ActiveRecord::Base
  include Accounts::Scoped
  include Auditable
  include Attributes::Strip
  include Customers::Validation
  include Customers::Searchable
  include Phonable

  attr_accessor :current_place_id, :kind

  strip_fields :name, :lastname, :identification, :address

  belongs_to :city
  has_many :jobs, as: :place, dependent: :destroy
  has_many :loans, through: :jobs

  def to_s
    [lastname, name].join(', ')
  end
  alias_method :label, :to_s
end
