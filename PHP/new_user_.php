<?php

	$password = "alderaan";
	$username = "luza2";
	$mail = "tt@taaatt";

	// ストアドプロシージャ実行関数読み込み
	require_once ("../php/stored.php");


	$str  = array_merge(range('a', 'z'), range('0', '9'), range('A', 'Z'),array(".","/"));

	$salt = "$2y$10$";

	for($i=0; $i<22; $i++){
		$salt .= $str[rand(0,count($str)-1)];
	}

	$salt .= "$";

	$hash = crypt($password, $salt);
	echo $hash ."<br>";

	// ストアドに渡す配列の作成
	$arg_arr = array(
        "twitter_cd" => ""
        ,"mail" => $mail
        ,"user_name" => $username
        ,"hash" => $hash
    );

	// ストアドプロシージャ呼び出し
	$result = stored("new_user_001",$arg_arr);

    // print_r($result);
    print_r($result);

    // echo $result;

	if(!$result["exit_cd"]){
        // 0以外は失敗
        echo json_encode("通信失敗");
	}else{
        echo json_encode("ユーザー作成完了");
        //echo ("ユーザー作成完了");
	}
?>