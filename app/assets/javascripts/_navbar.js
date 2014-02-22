$(document).ready(function() {
  var signed_in_status = $.cookie("signed_in_status");
  if(signed_in_status == "true"){
    set_type_nav();
  } else {
    $("#navbar_form").attr("action","/search/search_article");
    $("#search_nav").val("検索");
    /*$("#search_nav").val(I18n.t('search.search'));*/
    /*$("#searchtext_nav").attr("placeholder",I18n.t('placeholder.search_text'));*/
    $("#searchtext_nav").attr("placeholder","気になる言葉に関連する記事を検索しましょう！");
  }
});

function backToTop() {
  $("#backToTop a").click(function() {
    $("body,html").animate({
      scrollTop:0
    })
    return false
  });
}

function checkSearchtext(){
  if($('#searchtext_nav').val() == ""){
    $("#searchtext_nav").attr("placeholder","何か入力してボタンを押して下さい！");
    return false;
  }
}

function click_dropdown_manu_search(){
  $("#navbar_form").attr("action","/search/search_article");
  $("#navbar_form").attr("method","GET");
  $("#search_nav").val("検索");
  /*$("#search_nav").val(I18n.t('search.search'));*/
  /*$("#searchtext_nav").attr("placeholder",I18n.t('placeholder.search_text'));*/
  $("#searchtext_nav").attr("placeholder","気になる言葉に関連する記事を検索しましょう！");
  $.cookie('type_nav', 1, {path: '/'});
}

function click_dropdown_manu_add(){
  $("#navbar_form").attr("action","/webpage/add_confirm");
  $("#navbar_form").attr("method","POST");
  $("#navbar_form").attr("add_flag","true");
  $("#search_nav").val("登録");
  /*$("#search_nav").val(I18n.t('webpage.add'));*/
  /*$("#searchtext_nav").attr("placeholder",I18n.t('placeholder.input_url_text'));*/
  $("#searchtext_nav").attr("placeholder","URLを入力して記事を登録しましょう！");
  $.cookie('type_nav', 2, {path: '/'});
}

function set_type_nav(){
  var type_nav = $.cookie("type_nav");
  if(type_nav == "1") {
    click_dropdown_manu_search();
  } else {
    click_dropdown_manu_add();
  }
}