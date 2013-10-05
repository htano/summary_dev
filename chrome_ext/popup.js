/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text(bg.current_tab.title);
  $("p#p_url").text(bg.current_tab.url);

  $.ajax({
      url: 'http://' + bg.SERVICE_HOSTNAME + '/chrome/get_current_user_name_for_chrome_extension',
      type: 'GET',
      dataType: 'text',
      success: function(data) {
        if(!data){
          $("#a_link_to_login").attr("style", "visibility:visible;");
          setBtnDisabled();
        } else {
        	$.ajax({
        		url: 'http://' + bg.SERVICE_HOSTNAME + '/chrome/get_add_history_for_chrome_extension',
        		type: 'GET',
        		data: 'url=' + escape(bg.current_tab.url),
        		dataType: 'text',
        		success: function(data) {
        			if(data){
        				setCommentComplete();
        				setBtnDisabled();
        				setSummaryEditLink(data);
        			}
        		}
        	});
        }
      }
  });

  $.ajax({
      url: 'http://' + bg.SERVICE_HOSTNAME + '/chrome/get_recommand_tag_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'text',
      success: function(data) {
        //alert(data)
        $("p#p_recommand_tag").text(data);
      } 
  });

  $.ajax({
      url: 'http://' + bg.SERVICE_HOSTNAME + '/chrome/get_recent_tag_for_chrome_extension',
      type: 'GET',
      dataType: 'text',
      success: function(data) {
        //alert(data)
        $("p#p_recent_tag").text(data);
      } 
  });

  $('#p_button').click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: 'http://' + bg.SERVICE_HOSTNAME + '/chrome/add_for_chrome_extension',
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
});


//コメントを設定する
function setCommentComplete(){
  $('p#p_comment').text("登録済みです。");
  $('p#p_comment').attr("style", "visibility:visible;");
}

//要約編集画面へのリンクを設定する
function setSummaryEditLink(data){
  var bg = window.chrome.extension.getBackgroundPage();
  $("#a_link_to_summary_edit").attr("style", "visibility:visible;");
  $("#a_link_to_summary_edit").attr("href", "http://" + bg.SERVICE_HOSTNAME + "/summary/"+data+"/edit");
}

//登録ボタンを非活性にする。ついでにクラスも変更する。
function setBtnDisabled(){
  $('#p_button').attr("disabled", true);
  $('#p_button').attr("class", "button button-flat.disabled");
}
