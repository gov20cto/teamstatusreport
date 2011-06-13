class ApplicationController < ActionController::Base
  
  def initialize
    @allowed_ips = ['127.0.0.1','207.7.154','209.237.241','99.180.252']
    @scrumninja = ScrumNinja::Client.new('c17bafe18ce469e3a4300873de284dc24e3fcb78')
    super
  end
  
  def require_granicus_ip!
    allowed = false
    @allowed_ips.each do |ip|
      allowed = true if request.remote_ip.starts_with? ip
    end
    if not allowed then
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end
  end
  
  protect_from_forgery
end
