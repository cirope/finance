class Payment < ActiveRecord::Base
  include Auditable
  include Payments::Validation
  include Payments::Calculations
  include Payments::LoanUpdate
  include Payments::Relations
  include Payments::Scopes

  alias_attribute :amount, :payment
end
