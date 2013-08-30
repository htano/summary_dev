/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_comment2").text("popup2.jsです。");

  $.ajax({
      url: 'http://localhost:3000/summary_list/get_summary_list_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'json',
      success: function(data) {
        alert(data)
        //TODO JSON形式で帰ってきたものを画面に表示する
      });
  });
/*
  $('.popup_btn').click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: 'http://localhost:3000/webpage/add_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        setCommentComplete();
        setBtnDisabled();
        setSummaryEditLink(data);
      }
    });
  });

*/

});

/*

//既に登録されている旨のコメントを設定する
function setCommentAlreadyBooked(){
  $('p#p_comment').text("登録済みです。");
  $('p#p_comment').attr("style", "visibility:visible;");
}

//登録後のコメントを設定する
function setCommentComplete(){
  $('p#p_comment').text("登録が完了しました。");
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

*/