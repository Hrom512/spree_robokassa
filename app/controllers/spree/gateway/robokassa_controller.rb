class Spree::Gateway::RobokassaController < Spree::BaseController
  skip_before_filter :verify_authenticity_token, :only => [:result, :success, :fail]

  include Spree::Core::ControllerHelpers::Order

  helper 'spree/orders'
  helper 'spree/store'

  def show
    @order =  Spree::Order.find(params[:order_id])
    @order.state = params[:state] if params[:state]
    @gateway = @order.available_payment_methods.detect{|x| x.id == params[:gateway_id].to_i }

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t("invalid_arguments")
      redirect_to :back
    else
      @signature =  Digest::MD5.hexdigest([ @gateway.options[:mrch_login],
                                            @order.total, @order.number.gsub("R", ''), @gateway.options[:password1]
                                          ].join(':')).upcase

      render :action => :show
    end
  end

  def result
    @order = Spree::Order.find_by_number("R"+params["InvId"])
    @gateway = Spree::Gateway::Robokassa.current

    if @order && @gateway && valid_signature?(@gateway.options[:password2])
      robokassa_transaction = Spree::RobokassaTransaction.create
      payment = @order.payments.create(amount: params["OutSum"].to_f,
                                       payment_method: @gateway,
                                       source: robokassa_transaction)
      payment.complete!
      @order.next!

      render :text => "OK#{@order.id}"
    else
      render :text => "Invalid Signature"
    end
  end

  def success
    @order = Spree::Order.find_by_number("R"+params["InvId"])
    @gateway = Spree::Gateway::Robokassa.current
    if @order && @gateway && valid_signature?(@gateway.options[:password1]) && @order.complete?
      session[:order_id] = nil
      redirect_to order_path(@order), :notice => I18n.t("payment_success")
    else
      flash[:error] =  t("payment_fail")
      redirect_to root_url
    end
  end

  def fail
    flash[:error] = t("payment_fail")
    redirect_to @order.blank? ? root_url : checkout_state_path("payment")
  end

  private

  def valid_signature?(key)
    params["SignatureValue"].upcase == Digest::MD5.hexdigest([params["OutSum"], params["InvId"], key ].join(':')).upcase
  end

end
