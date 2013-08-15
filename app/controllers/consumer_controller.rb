require 'pathname'

require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  layout nil

  def index
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
    return_to = url_for :action => 'complete', :only_path => false, :fromUrl => params[:fromUrl]
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
      if(User.isExists?(session[:openid_url]))
        #redirect to any pages
        @uname = User.getName(session[:openid_url])
        flash[:success] = "Hello " + @uname + ". Login processing was successful."
        if User.updateLastLoginTime?(session[:openid_url])
          flash[:success] += "(" + User.getLastLogIn(session[:openid_url]).to_s + ")";
        else
        end
        if params[:fromUrl]
          flash[:alert] = "FromUrl is set: " + params[:fromUrl]
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
    session[:openid_url] = nil
    flash[:success] = "LogOut Complete."
    if params[:fromUrl]
      redirect_to params[:fromUrl]
    else
      redirect_to :action => 'index'
    end
  end

  # signup and signup_complete actions should belong to other controller.
  def signup
  end

  def signup_complete
    @creating_user_id = "#{params[:creating_user_id]}";
    if User.regist?(@creating_user_id, session[:openid_url])
      flash[:success] = "Hello " + @creating_user_id + ". SignUp was successfully completed."
      if params[:fromUrl]
        redirect_to params[:fromUrl]
      else
        redirect_to :controller => 'mypage',:action => 'index'
      end
    else
      flash[:error] = "SignUp Error: " + @creating_user_id + " has already exist."
      redirect_to :action => 'signup'
    end
  end

  def profile
    if(User.isExists?(session[:openid_url]))
      @uname = User.getName(session[:openid_url])
      @email = User.getMailAddr(session[:openid_url])
      if @email == nil
        @email = "(undefined)"
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :action => 'index'
    end
  end

  def profile_edit
    if(User.isExists?(session[:openid_url]))
      @uname = User.getName(session[:openid_url])
      @email = User.getMailAddr(session[:openid_url])
      if @email == nil
        @email = "(undefined)"
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :action => 'index'
    end
  end

  def profile_edit_complete
    @new_mail_address = params[:mail_addr]
    @confirm_mail_address = params[:mail_addr_confirm]
    @uploaded_image_file = params[:profile_image]
    
    @mail_change = (@new_mail_address != "")
    @redirect_url = url_for :action => 'profile'
    @session_error = false
    @edit_error = false
    if(User.isExists?(session[:openid_url]))
      if @mail_change
        if @new_mail_address == @confirm_mail_address
          User.updateMailAddr(@new_mail_address, session[:openid_url])
        else
          flash[:error] = "Different Mail Addresses were inputted."
          @edit_error = true
        end
      end
      if !@edit_error && @uploaded_image_file != nil
        @save_file_name = './app/assets/images/' + 'account_pictures/' + getLoginUser.id.to_s + '_uploaded_image_' + @uploaded_image_file.original_filename
        @for_db_image_path = 'account_pictures/' + getLoginUser.id.to_s + '_uploaded_image_' + @uploaded_image_file.original_filename
        File.open(@save_file_name, 'wb') do |of|
          of.write(@uploaded_image_file.read)
        end
        User.updateImagePath(session[:openid_url], @for_db_image_path)
      end
      if @edit_error
        redirect_to :action => 'profile_edit'
      else
        redirect_to :action => 'profile'
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :action => 'index'
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
