$(document).ready(function(){
    $(".login").on("click",function(){
        let username = "";
        let password = "";

        // クリックされたボタンの値を取得
        let val = this.value;
        let url = "";

        switch(val){
            case "login":
              // 通常ログイン用プロパティ設定

              // ユーザー名など未入力なら警告
              username = $("#username").val();
              password = $("#password").val();

              // phpファイル指定
              url = "../php/login_check.php"
              break;

            case "twitter":
              // TwitterAPI用プロパティ設定
              url = "../php/twitter_login.php"
              break;

            // 第一フェーズでは導入しない
            case "google":
              // Googleアカウント用プロパティ設定
              break;
        }

        $.ajax({
            // ログイン処理呼び出し
            url: url,
            cache: false,
            timeout: 10000,
            type:'POST',
            dataType: 'json',
            data:{
                username:username
                ,password:password
            }
        }).then(
            function(data){
                console.log(data);

                // 通信に成功してデータを取得したら遷移
                // TwitterやGoogleでログインする場合はここに戻ってこない
                //update(username).then(function(){
                    location.href="./index.html";
                //});

            },
            function(XMLHttpRequest, textStatus, errorThrown){
                // ログを吐き出す関数を作る
                console.log("通信に失敗しました");
                console.log("XMLHttpRequest : " + XMLHttpRequest.status);
                console.log("textStatus     : " + textStatus);
                console.log("errorThrown    : " + errorThrown.message);
            }
        );
    });

    // 新規登録ページに遷移
    $("#new_user").on("click",function(){
        location.href="./new_user.html";
    });
});


function update(username){
    $.ajax({
        // ユーザー名の変更を呼び出し(新規登録)
        url: "./update.php",
        cache: false,
        timeout: 10000,
        type:'POST',
        dataType: 'json',
        data:{
            username:username
        }
    }).then(
        function(data){
            console.log(data);
            return;
        },
        function(XMLHttpRequest, textStatus, errorThrown){
            console.log("更新処理に失敗しました");
            console.log("XMLHttpRequest : " + XMLHttpRequest.status);
            console.log("textStatus     : " + textStatus);
            console.log("errorThrown    : " + errorThrown.message);
            return;
        }
    );
}