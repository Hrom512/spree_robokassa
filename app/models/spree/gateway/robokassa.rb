module Spree
class Gateway::Robokassa < Gateway
  preference :password1, :string
  preference :password2, :string
  preference :mrch_login, :string

  def provider_class
    self.class
  end

  def method_type
    "robokassa"
  end

  def test?
    options[:test_mode] == true
  end

  def url
    self.test? ? "http://test.robokassa.ru/Index.aspx" : "https://merchant.roboxchange.com/Index.aspx"
  end

  def self.current
    self.where(:type => self.to_s, :active => true).first
  end

  def desc
    "<p>
      <label> #{Spree.t('robokassa.success_url')}: </label> http://[domain]/gateway/robokassa/success<br />
      <label> #{Spree.t('robokassa.result_url')}: </label> http://[domain]/gateway/robokassa/result<br />
      <label> #{Spree.t('robokassa.fail_url')}: </label> http://[domain]/gateway/robokassa/fail<br />
    </p>"
  end
end
end
