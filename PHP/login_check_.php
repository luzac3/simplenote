<?php
    // 平文パスワード
    $username = "aaa";
    $password = "aaaaaaa";

    $arg_arr = array(
        "username" => $username
    );

    // ストアド呼び出し用のファイルをロード
    require_once ("../php/stored.php");

    $result = stored("login_check_001",$arg_arr);

    if(!$result){
        echo ("ユーザー名が間違っています");
        return;
    }

    $hash = $result["HSH"];
    echo $hash;
    echo "<br>";
    echo crypt($password, $hash);

    // パスワードを検証する
    if (hash_equals($hash,crypt($password, $hash))) {
    	$_SESSION['username'] = $username;
    	$_SESSION['trk_num'] = $result["TRK_NUM"];

        // 正常終了
        // return 1;
        echo 1;
    } else {
        // パスワードが間違っている場合
        // return 2;
        echo 0;
    }

?>