<?php
if(!empty($_POST["new_content"])){
	$content = $_POST["new_content"];
	$cntnt_sral_num = $_POST["serial"];

	// ストアドプロシージャ実行関数読み込み
	require_once ("../php/stored.php");

	// ストアドに渡す配列の作成
	$arg_arr = array(
        "cntnt_sral_num" => $cntnt_sral_num
        ,"cntnt" => $content
	);

    // ストアドプロシージャ呼び出し
    $result = stored("new_content_001",$arg_arr);

    if(!$result){
        // 0以外は失敗
        echo json_encode("通信失敗");
    }
    if($mysqli -> query($sql)){
        echo 0;
    }else{
        echo json_encode("通信失敗");
    }
}else{
    echo json_encode("作成失敗");
}

?>