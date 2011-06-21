class ApplicationController < ActionController::Base
  
  def initialize
    @allowed_ips = APP_CONFIG['allowed_ip'].split(',')
    @scrumninja = ScrumNinja::Client.new(APP_CONFIG['scrumninja'])
    @project_map = {
      "platform" => "PT",
      "meeting efficiency" => "ME",
      "citizen participation" => "CP",
      "legislative management" => "LM",
    }
    super
  end
  
  def require_allowed_ip!
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