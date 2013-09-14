require 'pathname'

require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  layout nil

  def oauth_complete
    #logger.debug env['omniauth.auth'].to_yaml
    @oauth_url = "oauth://" + env['omniauth.auth']['provider'] + "/" + env['omniauth.auth']['uid']
    @image_url = env['omniauth.auth'].info.image
    session[:openid_url] = @oauth_url
    if getLoginUser
      @uname = getLoginUser.name
      flash[:success] = "Hello " + @uname + ". Login processing was successful."
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      if getLoginUser.updateLastLogin
        if env['omniauth.params']['keep_login'] == "on"
          cookies[:keep_login_token] = { :value => getLoginUser.keep_login_token, :expires => Time.now + 3.days }
          getLoginUser.updateKeepLogin(@remote_ip)
        end
      else
        #TODO Error handling
      end
      if env['omniauth.origin']
        redirect_to env['omniauth.origin']
      else
        redirect_to :controller => 'mypage', :action => 'index'
      end
    else
      if env['omniauth.origin']
        redirect_to :action => 'signup', :image => @image_url,:fromUrl => env['omniauth.origin']
      else
        redirect_to :action => 'signup', :image => @image_url
      end
    end
  end

  def index
    if signed_in?
      redirect_to :controller => 'mypage', :action => 'index'
    end
    # render an openid form
  end

  def start
    begin
      identifier = params[:openid_identifier]
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to :action => 'index'
        return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to :action => 'index'
      return
    end
    if params[:use_sreg]
      sregreq = OpenID::SReg::Request.new
      # required fields
      sregreq.request_fields(['email','nickname'], true)
      # optional fields
      sregreq.request_fields(['dob', 'fullname'], false)
      oidreq.add_extension(sregreq)
      oidreq.return_to_args['did_sreg'] = 'y'
    end
    if params[:use_pape]
      papereq = OpenID::PAPE::Request.new
      papereq.add_policy_uri(OpenID::PAPE::AUTH_PHISHING_RESISTANT)
      papereq.max_auth_age = 2*60*60
      oidreq.add_extension(papereq)
      oidreq.return_to_args['did_pape'] = 'y'
    end
    if params[:force_post]
      oidreq.return_to_args['force_post']='x'*2048
    end
    return_to = url_for :action => 'complete', :only_path => false, :fromUrl => params[:fromUrl], :keep_login => params[:keep_login]
    realm = url_for :action => '', :id => nil, :only_path => false
    
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    # FIXME - url_for some action is not necessarily the current URL.
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}.reject{|k,v| k == 'action' || k == 'controller'}
    #parameters = params.reject{|k,v|request.path_parameters[k]}
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SUCCESS
      flash[:success] = ("Verification of #{oidresp.display_identifier}"\
                         " succeeded.")
      if params[:did_sreg]
        sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)
        sreg_message = "Simple Registration data was requested"
        if sreg_resp.empty?
          sreg_message << ", but none was returned."
        else
          sreg_message << ". The following data were sent:"
          sreg_resp.data.each {|k,v|
            sreg_message << "<br/><b>#{k}</b>: #{v}"
          }
        end
        flash[:sreg_results] = sreg_message
      end
      if params[:did_pape]
        pape_resp = OpenID::PAPE::Response.from_success_response(oidresp)
        pape_message = "A phishing resistant authentication method was requested"
        if pape_resp.auth_policies.member? OpenID::PAPE::AUTH_PHISHING_RESISTANT
          pape_message << ", and the server reported one."
        else
          pape_message << ", but the server did not report one."
        end
        if pape_resp.auth_time
          pape_message << "<br><b>Authentication time:</b> #{pape_resp.auth_time} seconds"
        end
        if pape_resp.nist_auth_level
          pape_message << "<br><b>NIST Auth Level:</b> #{pape_resp.nist_auth_level}"
        end
        flash[:pape_results] = pape_message
      end
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
    else
    end
    case oidresp.status
    when OpenID::Consumer::SUCCESS
      session[:openid_url] = oidresp.display_identifier
      if getLoginUser
        @uname = getLoginUser.name
        flash[:success] = "Hello " + @uname + ". Login processing was successful."
        @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
        if getLoginUser.updateLastLogin
          if params[:keep_login] == "on"
            cookies[:keep_login_token] = { :value => getLoginUser.keep_login_token, :expires => Time.now + 3.days }
            getLoginUser.updateKeepLogin(@remote_ip)
          end
        else
        end
        if params[:fromUrl]
          redirect_to params[:fromUrl]
        else
          redirect_to :controller => 'mypage', :action => 'index'
        end
      else
        if params[:fromUrl]
          redirect_to :action => 'signup', :fromUrl => params[:fromUrl]
        else
          redirect_to :action => 'signup'
        end
      end
    else
      redirect_to :action => 'index'
    end
  end

  def sign_out
    getLoginUser.execSignOut
    session[:openid_url] = nil
    flash[:success] = "LogOut Complete."
    if params[:fromUrl]
      redirect_to :action => 'index', :fromUrl => params[:fromUrl]
    else
      redirect_to :action => 'index'
    end
  end

  def signup
    if !session[:openid_url]
      flash[:error] = "Error: To signup, you have to login by openid."
      redirect_to :action => 'index'
    end
  end

  def signup_complete
    if session[:openid_url]
      @creating_user_id = "#{params[:creating_user_id]}";
      @edit_profile_flg = (params[:edit_profile_flg] == "1")
      @error_message = User.regist(@creating_user_id, session[:openid_url])
      if !@error_message
        if params[:image]
          getLoginUser.updateImagePath(params[:image])
        end
        flash[:success] = "Hello " + @creating_user_id + ". SignUp was successfully completed."
        if @edit_profile_flg
          redirect_to :controller => 'settings', :action => 'profile_edit'
        else
          if params[:fromUrl]
            redirect_to params[:fromUrl]
          else
            redirect_to :controller => 'mypage',:action => 'index'
          end
        end
      else
        flash[:error] = @error_message
        redirect_to :back
      end
    else
      flash[:error] = "Error: To signup, you have to login by openid."
      redirect_to :action => 'index'
    end
  end

  def getUserExisting
    @uname = params[:creating_user_name]
    if User.is_exists?(@uname)
      render :text => "EXISTS"
    else
      render :text => "NONE"
    end
  end

  private

  def consumer
    if @consumer.nil?
      dir = Pathname.new(RAILS_ROOT).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end
end
