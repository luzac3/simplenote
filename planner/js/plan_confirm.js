$(document).ready(function(){
    //セッション(ストレージ)確認
    if(!storager.check("register")){
        location.href = "./session_timeout.html";
    }
    storager.set("timeout",1);

    //セッション破棄セット
    setTimeout(function(){
        storager.set("timeout",0);
    },30*60*1000)

    $("#register_button").on("click",function(){
        //ローカルストレージチェック
        if(!storager.get("timeout")){
            // ストレージのタイムアウトが発生したらデータを破棄
            storager.delete();
            location.href="./session_timeout.html";
            return;
        }

        let register = storager.get("register");
        console.log(register);

        let register_transact = storager.get("register_transact");
        console.log(register_transact);



        let arg_transact_arr = {};

        let str = "";
        let first = true;
        for(key in register_transact){
            if(first){
                first = false;
            }else{
                str += ",";
            }
            str += "(";
            register_transact[key].forEach(function(clmn){
                str += clmn;
                str += ",";
            });
            str = str.slice(0,-1);
            str += ")";
            arg_transact_arr[key] = str;
        }

        call_stored("stored_name",register).then(
            function(){
            	$.when(
                    arg_transact.forEach(function(arg_arr){
                        call_stored("stored_name",arg_arr);
                    })
                )
                .then(function(){
                	//成功
                },function(){
                	console.log(error);
                });

            },function(error){
                console.log(error);
            }
        );

    });

	$("#back_button").on("click",function(){
		location.href = "./register.html";
	})
});
