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
            
            if( isImage(files[i]) ){
                
                loadDataURL(files[i], function(dataURL){
                    appendDataURLImage(result, dataURL);
                });
                
            }
            
        }
        
    };
}
