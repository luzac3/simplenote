function call_stored(stored_name,arg_arr){
    if(arg_arr){
        this.arg_arr = arg_arr;
    }else{
        this.arg_arr = null;
    }
    console.log(this.arg_arr);

    return new Promise(function(resolve, reject){
        $.ajax({
            url: "../php/js_stored.php",
            cache: false,
            timeout: 10000,
            type:'POST',
            dataType: 'json',
            data:{
                stored_name:stored_name
                ,arg_arr:this.arg_arr
            }
        }).then(
            function(data){
                console.log(data);
                let ret = parseInt(data);

                console.log(ret);

                if(ret){
                    reject(ret);
                }
                resolve(ret);
                // return;
            },
            function(XMLHttpRequest, textStatus, errorThrown){
                console.log("更新処理に失敗しました");
                console.log("XMLHttpRequest : " + XMLHttpRequest.status);
                console.log("textStatus     : " + textStatus);
                console.log("errorThrown    : " + errorThrown.message);
                reject(0);
                // return;
            }
        );
    });
}