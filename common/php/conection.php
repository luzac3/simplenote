<?php

function db_connect($db_name){
    // db接続関数
    if ($_SERVER['REQUEST_URI'] == "localhost"){
        $server ="localhost";
        $username="root";
        $password="alderaan";
    }else{
        $server ="mysql622.db.sakura.ne.jp";
        $username="wolfnet-twei";
        $password="alderaan123";
    }

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
