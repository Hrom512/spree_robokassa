module SpreeRobokassa
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_robokassa'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_robokassa.add_payment_method" do |app|
      app.config.spree.payment_methods << Spree::Gateway::Robokassa
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end