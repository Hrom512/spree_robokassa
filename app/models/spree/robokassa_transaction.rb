module Spree
  class RobokassaTransaction < ActiveRecord::Base
    has_many :payments, :as => :source
  end
end
