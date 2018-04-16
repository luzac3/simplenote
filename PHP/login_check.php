<?php
session_start();
if(!empty($_POST)){
    // 平文パスワード
    $username = $_POST["username"];
    $password = $_POST["password"];

    $arg_arr = array(
        "user_name" => $username
    );

    // ストアド呼び出し用のファイルをロード
    require_once ("../php/stored.php");

    $result = stored("login_check_001",$arg_arr);

    if(!$result[0]){
        echo json_encode("ユーザー名が間違っています");
        return;
    }

    $hash = $result[0]["HSH"];

    // パスワードを検証する
    if (hash_equals($hash,crypt($password, $hash))) {
        $_SESSION['username'] = $username;
        $_SESSION['trk_num'] = $result[0]["TRK_NUM"];

        // 正常終了
        echo 1;
    } else {
        // パスワードが間違っている場合
        echo 2;
    }

}else{
    // 未知のエラー
    echo 0;
}

?>