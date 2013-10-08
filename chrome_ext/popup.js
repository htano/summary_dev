BLANK = ""

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
        if(data){
          data = removeMark(data);
          var tags = data.split(",");
          var i=1;
          var objBody = document.getElementById("recommend_tag");
          while(tags.length>=i){
            var element = document.createElement("span"); 
            element.id = "recommend_tag_"+(i);
            element.innerHTML = tags[i-1].trim();
            objBody.appendChild(element);
            //$("#recommend_tag_"+(i+1)).click(clickRecommendTag);
            //$("#recommend_tag_"+(i+1)).click(clickRecommendTag(tags[i].trim()));
            i++;
          }
          $("#recommend_tag").find("span").addClass("recommend_tag");
          //$("#recommend_tag").on("click", {class:"recommend_tag"}, clickRecommendTag());
          //$(".recommend_tag").click(clickRecommendTag("test"));
        }
      }
  });

  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_recent_tag",
      type: "GET",
      dataType: "text",
      success: function(data) {
        if(data){
          data = removeMark(data);
          var tags = data.split(",");
          var i=1;
          var objBody = document.getElementById("recent_tag");
          console.log(tags.length);
          while(tags.length>=i){
            console.log(i);
            var tag = tags[i-1].trim();
            var element = document.createElement("span"); 
            element.id = "recent_tag_"+(i);
            element.innerHTML = tag;
            //element.onclick = function(){clickRecentTag(tag)};
            //element.onclick = function(tag){ return clickRecentTag(tag) };
            //element.onclick = clickRecentTag(tags[i].trim());
            //element.setAttribute("onclick",clickRecentTag);
            objBody.appendChild(element);
            $("#recent_tag_"+(i)).click(function(){clickRecentTag(i)});
            //$(element.id).click(clickRecentTag());
            i++;
          }
          $("#recent_tag").find("span").addClass("recent_tag");
          //$(".recent_tag").click(clickRecentTag($(this)));
        }
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
/*
function clickRecommendTag(){
  alert("OK");
}
*/
function clickRecentTag(id){
  //document.getElementById("tag_text_1").value = value;
  console.log("!!!!!");
  console.log(id);
  console.log("!!!!!");
  value = document.getElementById("recent_tag_" + id).value();
  tag_class = document.getElementById("recent_tag_" + id).getAttribute("class")
  if (tag_class == "recent_tag"){
    var text_list = new Array();
    for (var i=1 ; i<=10 ; i++){
      text_list.push(document.getElementById("tag_text_" + i).value());
    }

    if(text_list.indexOf(value) != -1){
      document.getElementById("recent_tag_" + id).setAttribute("class", "recent_tag_pushed");
      return;
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value() == BLANK){
        document.getElementById("tag_text_" + i).value() = value;
        document.getElementById("recent_tag_" + id).setAttribute("class", "recent_tag_pushed");
        return;
      }
      alert("Please set tags within 10.");
    }

  } else {
    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value() == value){
        document.getElementById("tag_text_" + i).value() = BLANK;
        document.getElementById("recent_tag_" + id).setAttribute("class", "recent_tag");
        return;
      }
    }
  }
}