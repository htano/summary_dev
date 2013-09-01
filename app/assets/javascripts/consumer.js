$(function(){
    var twitter_href = $('a.zocial.twitter').attr('href');
    var facebook_href = $('a.zocial.facebook').attr('href');
    var github_href = $('a.zocial.github').attr('href');
    var yahoo_href = $('a.zocial.yahoo').attr('href');
    var google_href = $('a.zocial.google').attr('href');
    $('#keep_login_chk').click(function(){
      var isChecked = $('#keep_login_chk:checked').val();
      if(isChecked){
        $('a.zocial.twitter').attr('href', twitter_href + "&keep_login=on");
        $('a.zocial.facebook').attr('href', facebook_href + "&keep_login=on");
        $('a.zocial.github').attr('href', github_href + "&keep_login=on");
        $('a.zocial.yahoo').attr('href', yahoo_href + "&keep_login=on");
        $('a.zocial.google').attr('href', google_href + "&keep_login=on");
      } else {
        $('a.zocial.twitter').attr('href', twitter_href);
        $('a.zocial.facebook').attr('href', facebook_href);
        $('a.zocial.github').attr('href', github_href);
        $('a.zocial.yahoo').attr('href', yahoo_href);
        $('a.zocial.google').attr('href', google_href);
      }
    });
});

var p_num = 0; // To control multiple ajax access.
var format_ok = false;
function check_uid() {
  var user_name = $('#input_user_name').val();
  // Initialize the message of dupulication check.
  $("span#message_of_check_uname2").text("　");
  $("span#message_of_check_uname2").attr("style","");
  // Do format check
  if(!user_name.match(/^[A-Za-z0-9_-]{4,20}$/)) {
    format_ok = false;
    $("span#message_of_check_uname").text("UserID Format: NG");
    $("span#message_of_check_uname").attr("style","background-color:#ffaaaa; border: 1px solid #ff0000; padding: 3px 50px;");
  } else {
    format_ok = true;
    $("span#message_of_check_uname").text("UserID Format: OK");
    $("span#message_of_check_uname").attr("style","background-color:#aaffaa; border: 1px solid #00ff00; padding: 3px 50px;");
    // Do dupulication check
    $("img#ajax_loading").attr("hidden", false);
    p_num++;
    setTimeout(function(){
      p_num--;
      // Wait for multiple inputs.
      if(p_num == 0){
        $.ajax({
          url: '/session/consumer/getUserExisting',
          type: 'GET',
          data: 'creating_user_name=' + user_name,
          dataType: 'text',
          success: function(data) {
            $("img#ajax_loading").attr("hidden", true);
            if(format_ok) {
              if(data == "NONE") {
                $("span#message_of_check_uname2").text("You can use this user_id.");
                $("span#message_of_check_uname2").attr("style","background-color:#aaffaa; border: 1px solid #00ff00; padding: 3px 50px;");
              } else {
                $("span#message_of_check_uname2").text("Input user name has already existed.");
                $("span#message_of_check_uname2").attr("style","background-color:#ffaaaa; border: 1px solid #ff0000; padding: 3px 50px;");
              }
            }
          },
          error: function(data) {
            $("span#message_of_check_uname2").text("Server error has occured.");
            $("span#message_of_check_uname2").attr("style","background-color:#ffaaaa; border: 1px solid #ff0000; padding: 3px 50px;");
            $("img#ajax_loading").attr("hidden", true);
          }
        });
      }
    }, 1000);
  }
}

function display_input_image(win, doc) {
    
    if (win.File && win.FileReader && win.FileList && win.Blob){
    }else{
        
        alert("FILE APIに対応してないよん");
        return;
        
    }
    
    var inputFile = doc.getElementById("inputFile"),
        result = doc.getElementById("result");
    
    var isImage = function(file){
        
        return file.type.match("image.*")? true : false;
        
    };
    
    var loadDataURL = function(file, callback){
        
        var reader = new FileReader();
        
        reader.onload = function(){
            
            callback(this.result);
            
        };
        
        reader.readAsDataURL(file);
        
    };
    
    var appendDataURLImage = function(elem, dataURL){
        
        var img = doc.createElement("img");
        img.setAttribute("src", dataURL);
        img.setAttribute("width", "128px");
        img.setAttribute("height", "128px");
        elem.appendChild(img);
        
    };
    
    inputFile.onchange = function(){
                  
        var files = this.files;
        
        result.innerHTML = "";
                
        for(var i = 0; i < files.length; i++){
            $('.profile_btn').attr('disabled', true);
            if( isImage(files[i]) ){
                $('.profile_btn').attr('disabled', false);
                loadDataURL(files[i], function(dataURL){
                    appendDataURLImage(result, dataURL);
                });
                
            }
            
        }
        
    };
}
