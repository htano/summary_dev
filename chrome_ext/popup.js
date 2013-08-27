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
        if(!data){
          $("#a_link_to_login").attr("style", "visibility:visible;");
          setBtnDisabled();
        }
      }
  });

  $.ajax({
      url: 'http://localhost:3000/webpage/get_add_history_for_chrome_extension',
      type: 'GET',
      data: 'booked_url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        if(data){
          setBtnDisabled();
          setSummaryEditLink(data);
        }
      }
  });


  $('.popup_btn').click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: 'http://localhost:3000/webpage/add_for_chrome_extension',
      type: 'GET',
      data: 'booked_url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        setBookedComment();
        setBtnDisabled();
        setSummaryEditLink(data);
      }
    });
  });
});

//登録後のコメントを設定する
function setBookedComment(){
  $('p#p_comment').text("booked!");
  $('p#p_comment').attr("style", "visibility:visible;");
}

//要約編集画面へのリンクを設定する
function setSummaryEditLink(data){
  $("#a_link_to_summary_edit").attr("style", "visibility:visible;");
  $("#a_link_to_summary_edit").attr("href", "http://localhost:3000/summary/"+data+"/edit");
}

//登録ボタンを非活性にする。ついでにクラスも変更する。
function setBtnDisabled(){
  $('.popup_btn').attr("disabled", true);
  $('.popup_btn').attr("class", "btn_disabled");
}