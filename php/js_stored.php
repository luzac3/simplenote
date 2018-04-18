<?php
if(!empty($_POST)){

    // ストアドプロシージャ実行関数読み込み
    require_once ("../php/stored.php");

    // ストアド名を取得
    $stored = $_POST["stored_name"];

    // POSTデータ配列の取得
    $arg_arr = $_POST["arg_arr"];

    // 配列が存在しない場合、明示的にNULLを指定
    if(empty($arg_arr)){
        $arg_arr = null;
    }

    // ストアドプロシージャ呼び出し
    $result = stored($stored, $arg_arr);

    if($result){
        // 0以外は失敗
        echo json_encode($result["exit_cd"]);
        // echo json_encode("更新成功");
    }else{
        echo 0;
    }
}else{
    echo json_encode("実行失敗");
}

?>