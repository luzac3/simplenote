$(document).ready(function(){
    $("#password").on("keyup",function(){
        let pass = this.checkValidity();
        if(pass){
            $("#pass_error").html("OK");
        }else{
            $("#pass_error").html("6文字以上の半角英数で入力してください");
        }
    });

    $("#make").on("click",function(){
        // 二重送信防止 ボタンのDisabled



        // 終了フラグをTrueにセット
        let flag = true;

        let username = $("#username")[0];
        if(!username.checkValidity()){
            let str="";
            if(username.validity.valueMissing){
                str += "必須項目です<br>";
            }
            if(username.validity.patternMismatch){
                str += "半角英数で入力してください<br>"
            }
            str = str.slice(0,-4);
            $("#user_error").html(str);
            flag = false;
        }

        let pass1 = $("#password").val();
        let pass2 = $("#password_check").val();

        if(pass1 !== pass2){
            $("#pass_check_error").html("パスワードが一致しません");
            flag = false;
        }

        if(flag){
            username = username.value;
            console.log(username);
            console.log(pass1);

            let mail = $("#mail").val();
            $.ajax({
                url: "../php/new_user.php",
                cache: false,
                timeout: 10000,
                type:'POST',
                dataType: 'JSON',
                data:{
                    username:username
                    ,password:pass1
                    ,mail:mail
                }

            }).then(
                function(data){
                    console.log(data);
                    location.href="./index.html";
                },
                function(XMLHttpRequest, textStatus, errorThrown){
                    alert("通信に失敗しました");
                    console.log("XMLHttpRequest : " + XMLHttpRequest.status);
                    console.log("textStatus     : " + textStatus);
                    console.log("errorThrown    : " + errorThrown.message);
                }
            );

        }else{
            return 0;
        }
    });
    $("#back").on("click",function(){
        location.href="./login.html";
    });
});