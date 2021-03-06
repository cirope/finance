module Reminders::DestroyConstraints
  extend ActiveSupport::Concern

  included do
    before_destroy :allow_destruction?
  end

  def allow_destruction?
    !scheduled
  end
end
