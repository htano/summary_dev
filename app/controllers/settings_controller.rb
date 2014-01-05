# encoding: utf-8
require 'my_delayed_jobs'

class SettingsController < ApplicationController
  def profile
    @action_type = 'profile'
    unless get_login_user
      flash[:error] = "To show the profile page, you have to login."
      redirect_to(:controller => 'consumer', :action => 'index')
    end
  end

  def profile_edit
    profile
  end

  def profile_edit_complete
    public_flg = (params[:user_public_flg] == "TRUE")
    redirect_url = url_for(:action => 'profile')
    edit_flg = false
    edit_error = false
    user = get_login_user
    if user
      if(params[:user_full_name] &&
         params[:user_full_name] != user.full_name)
        user.full_name = params[:user_full_name]
        edit_flg = true
      end
      if(params[:user_comment] &&
         params[:user_comment] != user.comment)
        user.comment = params[:user_comment]
        edit_flg = true
      end
      if(params[:user_site_url] &&
         params[:user_site_url] != user.site_url)
        user.site_url = params[:user_site_url]
        edit_flg = true
      end
      if public_flg != user.public_flg
        user.public_flg = public_flg
        edit_flg = true
      end
      if !edit_error && params[:user] != nil
        if user.update_attributes(user_params)
          edit_flg = true
        else
          edit_error = true
        end
      end
      if edit_flg
        unless user.save
          edit_error = true
        end
      end
      if edit_error
        #TODO ModelでValidationをすれば、
        #errorsにエラーメッセージが入るはずなので、
        #flashとかに入れる
        redirect_url = url_for(:action => 'profile_edit')
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_url = url_for(:controller => 'consumer', 
                             :action => 'index')
    end
    redirect_to(redirect_url)
  end

  def email
    @action_type = 'email'
    if get_login_user
      case get_login_user.mail_addr_status
      when User::MAIL_STATUS_UNDEFINED
        @email_status = "　"
      when User::MAIL_STATUS_PROVISIONAL
        @email_status = "(provisional registration)"
        if(get_login_user.token_expire && 
           get_login_user.token_expire < Time.now)
          @email_status = "(provisional registration has been expired.)"
        end
      when User::MAIL_STATUS_DEFINITIVE
         @email_status = "(definitive registration)"
      when User::MAIL_STATUS_ERROR
        @email_status = "(error)"
      else
        @email_status = "(unknown status)"
      end
      @email = get_login_user.mail_addr
      if @email == nil
        @email = "(undefined)"
      else
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def email_edit
    email
  end

  def email_edit_complete
    @new_mail_address = params[:mail_addr]
    @confirm_mail_address = params[:mail_addr_confirm]
    @mail_change = (@new_mail_address && @new_mail_address != "")
    @redirect_url = url_for(:action => 'email')
    @session_error = false
    @edit_error = false
    if get_login_user
      if @mail_change
        if @new_mail_address == @confirm_mail_address
          if get_login_user.update_mail_address(@new_mail_address)
            mail_auth_url = url_for(
              :action => 'email_auth', 
              :token_uuid => get_login_user.token_uuid
            )
            job = MyDelayedJobs::MailingJob.new(
              get_login_user, 
              mail_auth_url
            )
            job.delay.run
            #begin
            #  fork do
            #    exec(Rails.root.to_s + 
            #         "/bin/delayed_job run --exit-on-complete")
            #  end
            #rescue => err
            #  logger.error("[email_edit_complete] #{err}")
            #end
          else
            logger.debug("Fail to update email address: " + @new_mail_address)
            # TODO 失敗した理由によってはエラーレベルを変える
            flash[:error] = "Can't change the mail address."
            @edit_error = true
          end
        else
          flash[:error] = "Different Mail Addresses were inputted."
          @edit_error = true
        end
      end
      if @edit_error
        @redirect_url = url_for(:action => 'email_edit')
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      @redirect_url = url_for(:controller => 'consumer', :action => 'index')
    end
    redirect_to(@redirect_url)
  end

  def email_auth
    @url_token_uuid = params[:token_uuid]
    if get_login_user
      if get_login_user.authenticate_updating_mailaddr(@url_token_uuid)
        flash[:success] = "MailAddress change has been authentificated."
        redirect_to(:action => 'email')
      else
        flash[:error] = "Token_uuid is not match or this token was expired."
        redirect_to(:action => 'email_edit')
      end
    else
      flash[:alert] = "To authentificate your mail change, you have to login."
      redirect_to(:controller => 'consumer', 
                  :action => 'index', 
                  :fromUrl => request.url)
    end
  end

  def account
    @action_type = 'account'
  end

  private
  def save_prof_image(user, img_file)
    image_file = 
      "#{user.id}_uploaded_image_#{img_file.original_filename}"
    db_path = "account_pictures/#{image_file}"
    save_path = "#{Rails.root}/public/images/#{db_path}"
    if(img_file.size < 1024 * 1024 &&
       img_file.content_type =~ /^image/)
      File.open(save_path, 'wb') do |of|
        of.write(img_file.read)
      end
      user.prof_image = db_path
      return true
    else
      flash[:error] = "Input image-file is not image file or exceeds 1024KB."
      return false
    end
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
