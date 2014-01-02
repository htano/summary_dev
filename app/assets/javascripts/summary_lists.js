$(function(){
  $("#display_preview").click(function(){
    $("#display_preview").hide(0);
    $("#hide_preview").show(0);
    $("#preview").slideDown(200);
  });

  $("#hide_preview").click(function(){
    $("#hide_preview").hide(0);
    $("#display_preview").show(0);
    $("#preview").slideUp(200);
  });

  $("#summary_box_body").each(function(){
     //http、httpsなどで始まる文字列を正規表現でリンクに置換する
     $(this).html( 
       $(this).html().replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, 
         '<a href="$1" target="_blank">$1</a> ') );
  });

  $("article").readmore({
    speed: 10,
    maxHeight: 200,
    moreLink: '<a href="#" class="readmore_char">続きを読む</a>',
    lessLink: '<a href="#" class="readmore_char">閉じる</a>'
  });
});
