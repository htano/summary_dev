/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_comment2").text("popup2.jsです。");
  $.ajax({
      url: 'http://localhost:3000/summary_lists/get_summary_list_for_chrome_extension',
      type: 'GET',
      data: 'url=' + escape(bg.current_tab.url),
      dataType: 'json',
      success: function(data) {
        if(data){
          for(var i in data){
            $('tbody').append('<tr class="table_top"><td>');
            $('tbody').append('<li>' + data[i].content + '</li>');
            $('tbody').append('</td></tr>');
          }
        }　else {
          $('tbody').append('<tr class="table_top"><td>');
          $('tbody').append('<li>この記事に対する要約は登録されていません。</li>');
          $('tbody').append('</td></tr>');
        }
      } 
  });
});