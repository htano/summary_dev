/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("img.a_load").attr("style", "visibility:visible;");
  $.ajax({
      url: 'http://' + bg.SERVICE_HOSTNAME + '/summary_lists/get_summary_list_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'json',
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        if(data && data.length != 0){
          for(var i in data){
            data_replace = data[i].content.replace(/\n|\r\n/g,"<br>");
            $('tbody').append('<tr><td>'+data_replace+'</td></tr>');
          }
        }　else {
          $('tbody').append('<tr><td>この記事に対する要約は登録されていません。</td></tr>');
        }
      } 
  });
});
