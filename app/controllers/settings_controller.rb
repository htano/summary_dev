class SettingsController < ApplicationController

  def profile
    @action_type = 'profile'
    if getLoginUser
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def profile_edit
    profile
  end

  def profile_edit_complete
    @uploaded_image_file = params[:profile_image]
    @redirect_url = url_for :action => 'profile'
    @session_error = false
    @edit_error = false
    if getLoginUser
      # TODO ファイルサイズや画像ファイルかどうかの判定をする。javascript側でもある程度やるとして、拡張子の確認くらいはする。
      if !@edit_error && @uploaded_image_file != nil
        @save_file_name = './app/assets/images/' + 'account_pictures/' + getLoginUser.id.to_s + '_uploaded_image_' + @uploaded_image_file.original_filename
        @for_db_image_path = 'account_pictures/' + getLoginUser.id.to_s + '_uploaded_image_' + @uploaded_image_file.original_filename
        File.open(@save_file_name, 'wb') do |of|
          of.write(@uploaded_image_file.read)
        end
        getLoginUser.updateImagePath(@for_db_image_path)
      end
      if @edit_error
        redirect_to :action => 'profile_edit'
      else
        redirect_to :action => 'profile'
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def email
    @action_type = 'email'
    if getLoginUser
      #TODO ステータスをdbから見るようにする
      case getLoginUser.mail_addr_status
      when User::MAIL_STATUS_UNDEFINED
        @email_status = "(undefined)"
      when User::MAIL_STATUS_PROVISIONAL
        @email_status = "(provisional registration)"
        if getLoginUser.token_expire && getLoginUser.token_expire < Time.now
          @email_status = "(provisional registration has been expired.)"
        end
      when User::MAIL_STATUS_DEFINITIVE
         @email_status = "(definitive registration)"
      when User::MAIL_STATUS_ERROR
        @email_status = "(error)"
      else
        @email_status = "(unknown status)"
      end
      @email = getLoginUser.mail_addr
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
    
    #TODO mailアドレスフォーマットチェックもモデルかjsかどっかでやる
    @mail_change = (@new_mail_address && @new_mail_address != "")
    @redirect_url = url_for :action => 'profile'
    @session_error = false
    @edit_error = false
    if getLoginUser
      if @mail_change
        if @new_mail_address == @confirm_mail_address
          if getLoginUser.updateMailAddr(@new_mail_address)
            @mail_auth_url = url_for :action => 'email_auth', :token_uuid => getLoginUser.token_uuid
            Message.change_mail_addr(getLoginUser.name, getLoginUser.mail_addr, @mail_auth_url).deliver
            #TODO token_urlにする
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
        redirect_to :action => 'email_edit'
      else
        redirect_to :action => 'email'
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def email_auth
    @url_token_uuid = params[:token_uuid]
    if getLoginUser
      if getLoginUser.authenticateUpdateMailAddr(@url_token_uuid)
        render :text => 'success'
      else
        render :text => 'token_uuid is not match or this token was expired.'
      end
    else
      render :text => 'you have to login'
    end
  end

  def account
    @action_type = 'account'
  end
end
