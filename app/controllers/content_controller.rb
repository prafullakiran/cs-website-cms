require 'base64'
require 'js_connect'

class ContentController < ApplicationController

  def madison
    render :layout => 'madison', :nothing => true
  end
  
  def forums

    user = {name: '', photourl: ''}
    if current_user
      user = {email: current_user.email, name: current_user.username, 
          photourl: current_user.profile_pic,
          uniqueid: current_user.username}
    end  
    user.merge!({client_id: ENV['VANILLA_CLIENT_ID']})    

    # json encode the user
    json = ActiveSupport::JSON.encode(user);     
    # base 64 encode the user json
    signature_string = Base64.strict_encode64(json)
    # Sign the signature string with current timestamp using hmac sha1
    signature = Digest::HMAC.hexdigest(signature_string + ' ' +  
      Time.now.to_i.to_s, ENV['VANILLA_SECRET'], Digest::SHA1)
    # build the final sso string
    @vanilla_sso = "#{signature_string} #{signature} #{Time.now.to_i} hmacsha1"  	

  end

  def forums_authenticate

    user = {name: '', photourl: ''}
    if current_user
      user = {email: current_user.email, name: current_user.username, 
          photourl: current_user.profile_pic,
          uniqueid: current_user.username}
    end    

    render :json => JsConnect::getJsConnectString(user, request, 
      ENV['VANILLA_CLIENT_ID'], ENV['VANILLA_SECRET']) 

  end
end
