BLANK = ""

/*TODO ホストの書き方*/
$(document).ready( function(){
  var bg = window.chrome.extension.getBackgroundPage();
  init(bg);

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
                if(data.article_id){
                  setEditTag();
                  setEditSummary(data.article_id);
                  hiddenReadLater();
                } else {
                  hiddenReadLater();
                }
              }
            }
          });
        } else {
          $("#link_to_login").show();
          setComment("ログインして下さい。");
          hiddenReadLater();
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
            var label = document.createElement('label');
            var element = document.createElement("span");
            element.id = "recommend_tag_"+(i);
            element.innerHTML = tags[i-1].trim();
            label.appendChild(element);
            objBody.appendChild(label);
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
            var label = document.createElement('label');
            var element = document.createElement("span");
            element.id = "recent_tag_"+(i);
            element.innerHTML = tag;
            label.appendChild(element);
            objBody.appendChild(label);
            $("#recent_tag_"+(i)).click(function(){clickRecentTag(this)});
            i++;
          }
          $("#recent_tag").find("span").addClass("recent_tag");
        }
      }
  });

  $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/get_set_tag",
      type: "GET",
      data: "url=" + escape(bg.current_tab.url),
      dataType: "text",
      success: function(data) {
        if(data){
          data = removeMark(data);
          var tags = data.split(",");
          var i=1;
          while(tags.length>=i){
            var tag = tags[i-1].trim();
            for (var j=1 ; j<=10 ; j++){
              if (document.getElementById("tag_text_"+j).value == BLANK) {
                document.getElementById("tag_text_"+j).value = tag
                break;
              }
            }

            for (var j=1 ; j<=10 ; j++){
              if (document.getElementById("recommend_tag_"+j).innerHTML == tag) {
                document.getElementById("recommend_tag_"+j).className = "recommend_tag_pushed";
                break;
              }
            }

            for (var j=1 ; j<=10 ; j++){
              if (document.getElementById("recent_tag_"+j).innerHTML == tag) {
                document.getElementById("recent_tag_"+j).className = "recent_tag_pushed";
                break;
              }
            }
            i++;
          }
        }
      }
  });
  
  $("#button_read_later").click(function(){
    $("#load").show();
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
        $("#load").hide();
        if (data.article_id != BLANK){
          setComment(data.msg);
          setEditSummary(data.article_id);
          setEditTag();
          hiddenReadLater();
        } else {
          setComment(data.msg);
        }
      }
    });
  });

  $("#link_to_edit_tag").click(function(){
    $("#load").show();
    $.ajax({
      url: "http://" + bg.SERVICE_HOSTNAME + "/chrome/edit_tag",
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
        $("#load").hide();
        setComment(data.msg);
      }
    });    
  });
});

function init(baclgroundpage){
  $("#title").text(baclgroundpage.current_tab.title);
  $("#comment").hide();
  $("#link_to_login").hide();
  $("#edit_tag").hide();
  $("#edit_summary").hide();
  $("#load").hide();
}

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
  $("#comment").text(msg);
  $("#comment").show();
}

function setEditTag(){
  $("#edit_tag").show();
}

//要約編集画面へのリンクを設定する
function setEditSummary(article_id){
  var bg = window.chrome.extension.getBackgroundPage();
  $("#edit_summary").show();
  $("#link_to_edit_summary").attr("href", "http://" + bg.SERVICE_HOSTNAME + "/summary/"+article_id+"/edit");
}

//登録ボタンを非活性にする。ついでにクラスも変更する。
function hiddenReadLater(){
  $("#button_read_later").hide();
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
        break;
      }
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("recent_tag_" + i).innerHTML == value){
        document.getElementById("recent_tag_" + i).className = "recent_tag_pushed";
        break;
      }
    }

  } else {
    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == value){
        document.getElementById("tag_text_" + i).value = BLANK;
        obj.className = "recommend_tag";
        break;
      }
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("recent_tag_" + i).innerHTML == value){
        document.getElementById("recent_tag_" + i).className = "recent_tag";
        break;
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
        break;
      }
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("recommend_tag_" + i).innerHTML == value){
        document.getElementById("recommend_tag_" + i).className = "recommend_tag_pushed";
        break;
      }
    }
  } else {
    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("tag_text_" + i).value == value){
        document.getElementById("tag_text_" + i).value = BLANK;
        obj.className = "recent_tag";
        break;
      }
    }

    for (var i=1 ; i<=10 ; i++){
      if (document.getElementById("recommend_tag_" + i).innerHTML == value){
        document.getElementById("recommend_tag_" + i).className = "recommend_tag";
        break;
      }
    }
  }
}