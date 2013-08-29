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
