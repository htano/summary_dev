require 'pathname'
require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  layout nil

  def oauth_complete
    @oauth_url = "oauth://" + env['omniauth.auth']['provider'] + 
      "/" + env['omniauth.auth']['uid']
    @image_url = env['omniauth.auth'].info.image
    session[:openid_url] = @oauth_url
    @redirect_url = url_for(:controller => 'mypage', :action => 'index')
    if getLoginUser
      @uname = getLoginUser.name
      flash[:success] = "Hello " + @uname + ". Login processing was successful."
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      if getLoginUser.update_last_login
        if env['omniauth.params']['keep_login'] == "on"
          getLoginUser.update_keep_login(@remote_ip)
          cookies[:keep_login_token] = {
            :value => getLoginUser.keep_login_token,
            :expires => Time.now + 3.days
          }
        end
      else
        #TODO Error handling
      end
      if env['omniauth.origin']
        @redirect_url = env['omniauth.origin']
      end
    else
      if env['omniauth.origin']
        @redirect_url = url_for(:action => 'signup',
                                :image => @image_url,
                                :fromUrl => env['omniauth.origin'])
      else
        @redirect_url = url_for(:action => 'signup', :image => @image_url)
      end
    end
    redirect_to(@redirect_url)
  end

  def index
    if signed_in?
      redirect_to(:controller => 'mypage', :action => 'index')
    end
    # render an openid form
  end

  def start
    begin
      identifier = params[:openid_identifier]
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to(:action => 'index')
        return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to(:action => 'index')
      return
    end
    return_to = url_for(:action => 'complete',
                        :only_path => false,
                        :fromUrl => params[:fromUrl],
                        :keep_login => params[:keep_login])
    realm = url_for :action => '', :id => nil, :only_path => false
    
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to(oidreq.redirect_url(realm, return_to, params[:immediate]))
    else
      render(:text => oidreq.html_markup(realm,
                                         return_to,
                                         params[:immediate],
                                         {'id' => 'openid_form'}))
    end
  end

  def complete
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}.reject{|k,v| k == 'action' || k == 'controller'}
    oidresp = consumer.complete(parameters, current_url)
    @redirect_url = url_for(:action => 'index')
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
    when OpenID::Consumer::SUCCESS
      flash[:success] = ("Verification of #{oidresp.display_identifier}"\
                         " succeeded.")
      session[:openid_url] = oidresp.display_identifier
      if getLoginUser
        @uname = getLoginUser.name
        flash[:success] = "Hello " + @uname + ". Login processing was successful."
        @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
        if getLoginUser.update_last_login
          if params[:keep_login] == "on"
            getLoginUser.update_keep_login(@remote_ip)
            cookies[:keep_login_token] = {
              :value => getLoginUser.keep_login_token,
              :expires => Time.now + 3.days
            }
          end
        end
        if params[:fromUrl]
          @redirect_url = params[:fromUrl];
        else
          @redirect_url = url_for(:controller => 'mypage', :action => 'index')
        end
      else
        if params[:fromUrl]
          @redirect_url = url_for(:action => 'signup',
                                  :fromUrl => params[:fromUrl])
        else
          @redirect_url = url_for(:action => 'signup')
        end
      end
    else
    end
    redirect_to(@redirect_url)
  end

  def sign_out
    getLoginUser.exec_sign_out
    session[:openid_url] = nil
    flash[:success] = "LogOut Complete."
    if params[:fromUrl]
      redirect_to(:action => 'index', :fromUrl => params[:fromUrl])
    else
      redirect_to(:action => 'index')
    end
  end

  def signup
    if session[:openid_url]
      if getLoginUser
        redirect_to(:controller => 'mypage', :action => 'index')
      end
    else
      flash[:error] = "Error: To signup, you have to login by openid."
      redirect_to(:action => 'index')
    end
  end

  def signup_complete
    if session[:openid_url]
      if getLoginUser
        redirect_to(:controller => 'mypage', :action => 'index')
      else
        @creating_user_id = "#{params[:creating_user_id]}";
        @edit_profile_flg = (params[:edit_profile_flg] == "1")
        @error_message = User.regist(@creating_user_id, session[:openid_url])
        if !@error_message
          if params[:image]
            getLoginUser.update_image_path(params[:image])
          end
          flash[:success] = "Hello " + @creating_user_id +
            ". SignUp was successfully completed."
          if @edit_profile_flg
            redirect_to(:controller => 'settings', :action => 'profile_edit')
          else
            if params[:fromUrl]
              redirect_to(params[:fromUrl])
            else
              redirect_to(:controller => 'mypage',:action => 'index')
            end
          end
        else
          flash[:error] = @error_message
          redirect_to(:back)
        end
      end
    else
      flash[:error] = "Error: To signup, you have to login by openid."
      redirect_to(:action => 'index')
    end
  end

  def get_user_existing
    @uname = params[:creating_user_name]
    if User.exists?(@uname)
      render(:text => "EXISTS")
    else
      render(:text => "NONE")
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
