$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("#p_title").text() );
  $("img.a_load").show();
  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_summary_list",
      type: "GET",
      data: "url=" + escape(bg.current_tab.url),
      dataType: "json",
      success: function(data) {
        $("img.a_load").hide();
        if(data && data.length != 0){
          for(var i in data){
            data_replace = data[i].content.replace(/\n|\r\n/g,"<br>");
            $("tbody").append("<tr><td>"+data_replace+"</td></tr>");
          }
        }　else {
          $("tbody").append("<tr><td>"+chrome.i18n.getMessage("no_summary")+"</td></tr>");
        }
      }
  });
});