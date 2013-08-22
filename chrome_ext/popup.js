$(document).ready(function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text( bg.current_tab.title);
  $("p#p_url").text( bg.current_tab.url);
});
