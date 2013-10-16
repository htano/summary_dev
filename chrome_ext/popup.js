BLANK = ""

/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  $("p#p_title").text(bg.current_tab.title);

  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_login_user_id",
      type: "GET",
      dataType: "text",
      success: function(data) {
        if(data){
          $.ajax({
            url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_article_data",
            type: "GET",
            data: "url=" + escape(bg.current_tab.url),
            dataType: "json",
            success: function(data) {
              if(data.msg){
                setComment(data.msg);
                setBtnDisabled();
                if(data.article_id){
                  setSummaryEditLink(data.article_id);
                }
              }
            }
          });
        } else {
          $("#a_link_to_login").attr("style", "visibility:visible;");
          setComment("ログインして下さい。");
          hiddenBtnDisabled();
          hiddenTagArea();
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
            $("#recommend_tag_"+(i)).click(function(){clickRecommendTag(this)});
            i++;
          }
          $("#recommend_tag").find("span").addClass("recommend_tag");
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
          while(tags.length>=i){
            var tag = tags[i-1].trim();
            var element = document.createElement("span"); 
            element.id = "recent_tag_"+(i);
            element.innerHTML = tag;
            objBody.appendChild(element);
            $("#recent_tag_"+(i)).click(function(){clickRecentTag(this)});
            i++;
          }
          $("#recent_tag").find("span").addClass("recent_tag");
        }
      }
  });
  
  //TODO タグ情報を送信してChromeからでもタグ有で登録出来るようにする
  $("#p_button").click(function(){
    $("img.a_load").attr("style", "visibility:visible;");
    $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/add",
      type: "GET",
      data: {
        url: bg.current_tab.url,
        tag_text_1: document.getElementById("tag_text_1").value,
        tag_text_2: document.getElementById("tag_text_2").value,
        tag_text_3: document.getElementById("tag_text_3").value,
        tag_text_4: document.getElementById("tag_text_4").value,
        tag_text_5: document.getElementById("tag_text_5").value,
        tag_text_6: document.getElementById("tag_text_6").value,
        tag_text_7: document.getElementById("tag_text_7").value,
        tag_text_8: document.getElementById("tag_text_8").value,
        tag_text_9: document.getElementById("tag_text_9").value,
        tag_text_10: document.getElementById("tag_text_10").value
      },
      dataType: "json",
      success: function(data) {
        $("img.a_load").attr("style", "visibility:hidden;");
        if (data.article_id != BLANK){
          setComment(data.msg);
          setBtnDisabled();
          setSummaryEditLink(data.article_id);          
        } else {
          setComment(data.msg);
        }
      }
    });
  });
});

function hiddenTagArea(){
  $("#recommend_tag_title").hide();
  $("#recommend_tag_data").hide();
  $("#recent_tag_title").hide();
  $("#recent_tag_data").hide();
  $("#my_tag_title").hide();
  $("#my_tag_data").hide();
}

function removeMark(str){
  str = str.replace("[", "");
  str = str.replace("]", "");
  str = str.replace(new RegExp("\"", "g"), "");
  return str;
}

//コメントを設定する
function setComment(msg){
  $("p#p_comment").text(msg);
  $("p#p_comment").attr("style", "visibility:visible;");
}

//要約編集画面へのリンクを設定する
function setSummaryEditLink(article_id){
  var bg = window.chrome.extension.getBackgroundPage();
  $("#a_link_to_summary_edit").attr("style", "visibility:visible;");
  $("#a_link_to_summary_edit").attr("href", "http://" + bg.SERVICE_HOSTNAME + "/summary/"+article_id+"/edit");
}

//登録ボタンを隠す
function hiddenBtnDisabled(){
  $("#p_button").hide();
}

//登録ボタンを非活性にする。ついでにクラスも変更する。
function setBtnDisabled(){
  $("#p_button").attr("disabled", true);
  $("#p_button").attr("class", "button button-flat.disabled");
}

function clickRecommendTag(obj){
  value = obj.innerHTML
  if (obj.className == "recommend_tag"){
    var text_list = new Array();
    for (var i=1 ; i<=10 ; i++){
      text_list.push(document.getElementById("tag_text_" + i).value);
    }

    if(text_list.indexOf(value) != -1){ 
      obj.className = "recommend_tag_pushed";
      return;
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == BLANK){
        document.getElementById("tag_text_" + i).value = value;
        obj.className = "recommend_tag_pushed";
        return;
      }
    }

  } else {
    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == value){
        document.getElementById("tag_text_" + i).value = BLANK;
        obj.className = "recommend_tag";
        return;
      }
    }
  }
}


function clickRecentTag(obj){
  value = obj.innerHTML
  if (obj.className == "recent_tag"){
    var text_list = new Array();
    for (var i=1 ; i<=10 ; i++){
      text_list.push(document.getElementById("tag_text_" + i).value);
    }

    if(text_list.indexOf(value) != -1){ 
      obj.className = "recent_tag_pushed";
      return;
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == BLANK){
        document.getElementById("tag_text_" + i).value = value;
        obj.className = "recent_tag_pushed";
        return;
      }
    }

  } else {
    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == value){
        document.getElementById("tag_text_" + i).value = BLANK;
        obj.className = "recent_tag";
        return;
      }
    }
  }
}
/*
$("#test").click(function(){
  for (var i=1 ; i<=10 ; i++){
    document.getElementById('tag_text_' + i).value = BLANK
  }
  alert("clickDelete()");
});
*/