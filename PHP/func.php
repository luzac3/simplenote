<?php
function order_by($sort_cd,$ud_cd,$mysqli){
	//ud_cd 0:ASC、1:DESC
	$ud = array(
        '0'=>'ADC'
        ,'1'=>'DESC'
    );

	$array_ud_cd = explode(",", $ud_cd);
	$array_sort = array();

	$sort_cd_arr = explode(",",$sort_cd);
	$order_by = "";

	foreach ($sort_cd_arr as $key => $value){
		$order_by .= "WHEN ".  $value[$key]. "THEN ". $key;
	}
	$order_by .= " ELSE 0 END";

    //ストアドプロシージャ呼び出し
    $sql = "CALL func_001('.$sort_cd.','.$order_by.',@exit_cd)";
    if($mysqli->query($sql)){
        $result = $mysqli->query("SELECT @exit_cd AS exit_cd");
        if(exit_cd){
            return exit_cd;
        }
        while ($row = mysqli_fetch_assoc($result)) {
            $array_sort[$row["SORT_CD"]] = $row["SORT_NAME"];
        }
    }else{
        return 100;
    }

	$result -> close();

	$sort = "ORDER BY";
	$num = 0;

	foreach ($array_sort_cd as $value) {
		$sort .= " ".$array_sort[$num]." ".$ud[$array_ud_cd[$num]];
		$num++;
	}

	return $sort;
}
?>