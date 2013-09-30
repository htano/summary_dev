# encoding: utf-8

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
    @uploaded_image_file = params[:profile_image]
    @user_full_name = params[:user_full_name]
    @user_comment = params[:user_comment]
    @user_site_url = params[:user_site_url]
    @user_public_flg = (params[:user_public_flg] == "TRUE")
    @redirect_url = url_for(:action => 'profile')
    @edit_flg = false
    @edit_error = false
    @error_message = ""
    @login_user = get_login_user
    if @login_user
      if @user_full_name && @user_full_name != @login_user.full_name
        logger.debug @user_full_name
        @login_user.full_name = @user_full_name
        @edit_flg = true
      end
      if @user_comment && @user_comment != @login_user.comment
        @login_user.comment = @user_comment
        @edit_flg = true
      end
      if @user_site_url && @user_site_url != @login_user.site_url
        @login_user.site_url = @user_site_url
        @edit_flg = true
      end
      if @user_public_flg != @login_user.public_flg
        @login_user.public_flg = @user_public_flg
        @edit_flg = true
      end
      if !@edit_error && @uploaded_image_file != nil
        logger.debug("image file size: " + @uploaded_image_file.size.to_s + " Byte")
        logger.debug("image content type: " + @uploaded_image_file.content_type + "")
        if(@uploaded_image_file.size < 1024 * 1024 &&
           @uploaded_image_file.content_type =~ /^image/)
          @save_file_name = './public/images/' +
            'account_pictures/' + 
            @login_user.id.to_s + 
            '_uploaded_image_' + 
            @uploaded_image_file.original_filename
          @for_db_image_path = 'account_pictures/' + 
            @login_user.id.to_s + 
            '_uploaded_image_' + 
            @uploaded_image_file.original_filename
          File.open(@save_file_name, 'wb') do |of|
            of.write(@uploaded_image_file.read)
          end
          @login_user.prof_image = @for_db_image_path
          @edit_flg = true
        else
          @edit_error = true
          flash[:error] = "Input image-file is not image file or exceeds 1024KB."
        end
      end
      if @edit_flg
        unless @login_user.save
          @edit_error = true
        end
      end
      if @edit_error
        #TODO ModelでValidationをすれば、
        #errorsにエラーメッセージが入るはずなので、flashとかに入れる
        logger.debug @login_user.errors.to_yaml
        @redirect_url = url_for(:action => 'profile_edit')
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      @redirect_url = url_for(:controller => 'consumer', :action => 'index')
    end
    redirect_to(@redirect_url)
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
            @mail_auth_url = url_for(:action => 'email_auth', 
                                     :token_uuid => get_login_user.token_uuid)
            Message.change_mail_addr(get_login_user.name, 
                                     get_login_user.mail_addr, 
                                     @mail_auth_url).deliver
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
end
