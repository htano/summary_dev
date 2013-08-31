/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("img.a_load").attr("style", "visibility:visible;");
  $.ajax({
      url: 'http://localhost:3000/summary_lists/get_summary_list_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'json',
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        if(data && data.length != 0){
          for(var i in data){
            $('tbody').append('<tr><td>'+data[i].content+'</td></tr>');
          }
        }　else {
          $('tbody').append('<tr><td>この記事に対する要約は登録されていません。</td></tr>');
        }
      } 
  });
});