/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text(bg.current_tab.title);
  $("p#p_url").text(bg.current_tab.url);
  $.ajax({
      url: 'http://localhost:3000/webpage/get_current_user_name_for_chrome_extension',
      type: 'GET',
      dataType: 'text',
      success: function(data) {
        if(data){
          $("p#p_user").text(data);
        }else{
          $('.popup_btn').attr("disabled", true);
          $('.popup_btn').attr("class", "btn_disabled");
          $("#a_link").attr("style", "visibility:visible;");
        }
      }
  });

  $.ajax({
      url: 'http://localhost:3000/webpage/get_add_history',
      type: 'GET',
      data: 'booked_url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        if(data){
          $('.popup_btn').text("登録済みです。");
          $('.popup_btn').attr("disabled", true);
          $('.popup_btn').attr("class", "btn_disabled");
        }
      }
  });


  $('.popup_btn').click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: 'http://localhost:3000/webpage/add',
      type: 'GET',
      data: 'booked_url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        $("p#p_comment").attr("style", "visibility:visible;");
        $("p#p_comment").text(data);
      },
      error: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        $("p#p_comment").attr("style", "visibility:visible;");
        $("p#p_comment").text("システム管理者に連絡して下さい！");
      }
    });
  });
});