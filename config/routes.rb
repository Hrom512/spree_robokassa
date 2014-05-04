Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :gateway do
    get '/robokassa/:gateway_id/:order_id' => 'robokassa#show',    as: :robokassa
    get '/robokassa/result'                => 'robokassa#result',  as: :robokassa_result
    get '/robokassa/success'               => 'robokassa#success', as: :robokassa_success
    get '/robokassa/fail'                  => 'robokassa#fail',    as: :robokassa_fail
  end

end
