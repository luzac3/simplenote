<?php
// リクエストトークンを使い、アクセストークンを取得する
$twitter_connect = new TwitterOAuth(TWITTER_API_KEY, TWITTER_API_SECRET, $_SESSION['oauth_token'], $_SESSION['oauth_token_secret']);
$access_token = $twitter_connect->oauth('oauth/access_token', array('oauth_verifier' => $_GET['oauth_verifier'], 'oauth_token'=> $_GET['oauth_token']));

// アクセストークンからユーザの情報を取得する
$user_connect = new TwitterOAuth(TWITTER_API_KEY, TWITTER_API_SECRET, $access_token['oauth_token'], $access_token['oauth_token_secret']);

// アカウントの有効性を確認するためのエンドポイント
$user_info = $user_connect->get('account/verify_credentials');


if(isset($user_info["id_str"])){
    // アカウント名
    $id = $user_info["id_str"];

    // 引数として渡す配列の作成
    $arr_ui = array(
        'id' => $id
        ,'oauth_token' => $_SESSION['oauth_token']
        ,'oauth_token_secret' => $_SESSION['oauth_token_secret']
    );
    // トークン情報を破棄
    unset($_SESSION("oauth_token"));
    unset($_SESSION("oauth_token_secret"));

     // TwitterIDと名前をセッションに保存
    $_SESSION['screen_name'] = $user_info["screen_name"];
    $_SESSION['name'] = $user_info["name"];

    // ユーザーアカウント情報を登録・更新する
    // 新規作成
    $result = stored("",$arr_ui);

    // 戻ってきたユーザー登録番号をセッションに保存
    $_SESSION["trk_num"] = $result[0]["TRK_NUM"];

    if($result){
        // 戻り値が0以外はエラー(エラー情報をGETで返す)
        header("Location:../html/error.html");
    }else{
        header("Location:../html/auto_tweet.html");
    }
}else{
    header("Location:../html/error.html");
}
?>