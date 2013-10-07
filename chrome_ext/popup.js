BLANK = ''

/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  console.log( $("p#p_title").text() );
  $("p#p_title").text(bg.current_tab.title);
  $("p#p_url").text(bg.current_tab.url);

  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_current_user_name",
      type: "GET",
      dataType: "text",
      success: function(data) {
        if(!data){
          $("#a_link_to_login").attr("style", "visibility:visible;");
          setBtnDisabled();
        } else {
        	$.ajax({
        		url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_add_history",
        		type: "GET",
        		data: "url=" + escape(bg.current_tab.url),
        		dataType: "text",
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
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_recommend_tag",
      type: "GET",
      data: "url=" + escape(bg.current_tab.url),
      dataType: "text",
      success: function(data) {
        data = removeMark(data);
        var tags = data.split(",");
        var i=0;
        var objBody = document.getElementById("recommend_tag");
        while(tags.length>i){
          var element = document.createElement("span"); 
          element.id = "recommend_tag_"+(i+1);
          element.innerHTML = tags[i];
          objBody.appendChild(element);
          i++;
        }
        $("#recommend_tag").find("span").addClass("recommend_tag");
//        $("#recommend_tag").on("click", {class:"recommend_tag"}, clickRecommendTag());
      } 
  });

  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_recent_tag",
      type: "GET",
        dataType: "text",
      success: function(data) {
        data = removeMark(data);
        var tags = data.split(",");
        var i=0;
        var objBody = document.getElementById("recent_tag");
        while(tags.length>i){
          var element = document.createElement("span"); 
          element.id = "recent_tag_"+(i+1);
          element.innerHTML = tags[i];
          objBody.appendChild(element);
          i++;
        }
        $("#recent_tag").find("span").addClass("recent_tag");
      } 
  });

  $("#p_button").click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/add",
      type: "GET",
      data: "url=" + escape(bg.current_tab.url),
      dataType: "text",
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        setCommentComplete();
        setBtnDisabled();
        setSummaryEditLink(data);
      }
    });
  });
});

function removeMark(str){
  str = str.replace("[", "");
  str = str.replace("]", "");
  str = str.replace(" ", "");
  str = str.replace(new RegExp("\"", "g"), "");
  return str;
}

//コメントを設定する
function setCommentComplete(){
  $("p#p_comment").text("登録済みです。");
  $("p#p_comment").attr("style", "visibility:visible;");
}

//要約編集画面へのリンクを設定する
function setSummaryEditLink(data){
  var bg = window.chrome.extension.getBackgroundPage();
  $("#a_link_to_summary_edit").attr("style", "visibility:visible;");
  $("#a_link_to_summary_edit").attr("href", "http://" + bg.SERVICE_HOSTNAME + "/summary/"+data+"/edit");
}

//登録ボタンを非活性にする。ついでにクラスも変更する。
function setBtnDisabled(){
  $("#p_button").attr("disabled", true);
  $("#p_button").attr("class", "button button-flat.disabled");
}

function clickRecommendTag(){
  alert("OK");
}
