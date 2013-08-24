/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text(bg.current_tab.title);
  $("p#p_url").text(bg.current_tab.url);
/*  alert('カマン')
  $.ajax({
      url: 'http://localhost:3000/webpage/signed_in?',
      type: 'GET',
      success: function(data) {
        chrome.browserAction.setBadgeText({text:String(data)});
      },
      error: function(data) {
        alert("失敗");
      }
  });
*/
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
