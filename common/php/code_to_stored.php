<?php
function code_to_stored($table_name,$cd_name,$code_list){
    // ストアドプロシージャ実行関数読み込み
    require_once ("../php/stored.php");

    $arg_arr = array(
        "sql" => list_to_str($table_name,$cd_name,$code_list)
    );

    $result = stored("code_to_stored_001",$arg_arr);

    return $result;
}

function list_to_str($table_name,$cd_name,$code_list) {
    $first_i = key(array_slice($array, 0, 1, true));
    $last_i  = key(array_slice($array, -1, 1, true));
    $str = "";
    foreach ($code_list as $i => $val) {
        $str .= "SELECT";
        $str .= " NAME";
        $str .= " FROM";
        $str .= " ";
        $str .= $table_name;
        $str .= " WHERE";
        $str .= " ";
        $str .= $cd_name;
        $str .= " =";
        $str .= " '".$val."'";
        if ($i === $last_i) {
        	// 最後にはつけない
            $str .= " UNION ALL";
        }
    }
    return $str;
}
?>