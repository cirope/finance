class Phone < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Phones::Validation

  strip_fields :phone

  belongs_to :phonable, polymorphic: true

  def to_s
    phone
  end
end
