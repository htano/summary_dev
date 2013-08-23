$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text(bg.current_tab.title);
  $("p#p_url").text(bg.current_tab.url);

  $('.popup_btn').click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: 'http://localhost:3000/webpage/add',
      type: 'GET',
      data: 'booked_url=' + escape(bg.current_tab.url),
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        $("p#p_comment").attr("style", "visibility:visible;");
        $("p#p_comment").text("登録しました。");
      },
      error: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        $("p#p_comment").attr("style", "visibility:visible;");
        $("p#p_comment").text("失敗しました、urlを確認して下さい。");
      }
    });
  });
});
