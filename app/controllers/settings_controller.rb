class SettingsController < ApplicationController

  def profile
    @action_type = 'profile'
    if getLoginUser
      @uname = getLoginUser.name
      @email = getLoginUser.mail_addr
      if @email == nil
        @email = "(undefined)"
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def profile_edit
    @action_type = 'profile'
    if getLoginUser
      @uname = getLoginUser.name
      @email = getLoginUser.mail_addr
      if @email == nil
        @email = "(undefined)"
      end
    else
      flash[:error] = "To show the profile page, you have to login."
      redirect_to :controller => 'consumer', :action => 'index'
    end
  end

  def profile_edit_complete
    @new_mail_address = params[:mail_addr]
    @confirm_mail_address = params[:mail_addr_confirm]
    @uploaded_image_file = params[:profile_image]
    
    #@mail_change = (@new_mail_address != "")
    @mail_change = false
    @redirect_url = url_for :action => 'profile'
    @session_error = false
    @edit_error = false
    if getLoginUser
      if @mail_change
        if @new_mail_address == @confirm_mail_address
          if getLoginUser.updateMailAddr(@new_mail_address)
            Message.change_mail_addr(getLoginUser.name, getLoginUser.mail_addr, "http://localhost:3000/mypage/index").deliver
          else
            logger.debug("Fail to update email address: " + @new_mail_address)
            # TODO 失敗した理由によってはエラーレベルを変える
          end
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
      @email_status = "(undefined) / (provisional registration) / (definitive registration) / (expired)"
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
    @action_type = 'email'
    if getLoginUser
      #TODO ステータスをdbから見るようにする
      @email_status = "(undefined) / (provisional registration) / (definitive registration) / (expired)"
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

  def email_edit_complete
  end

  def account
    @action_type = 'account'
  end
end
