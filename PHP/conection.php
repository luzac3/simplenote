<?php

function db_connect($db_name){
    // db接続関数
    $server ="mysql622.db.sakura.ne.jp";
    // $server ="localhost";
    // $username="root";
    $username="wolfnet-twei";
    // $password="alderaan";
    $password="alderaan123";

    $mysqli = new mysqli($server,$username,$password,$db_name);

    if($mysqli->connect_error){
        echo $mysqli->connect_error;
        exit();
    }else{
        $mysqli->set_charset("utf8");
    }
    return $mysqli;
}
?>
