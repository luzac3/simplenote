<?php
// セキュリティ及び管理の観点から考えて、DBより取得に変更
define('CONSUMER_KEY', 'US1wRncfyzig9e3oF1KnK7WNG');
define('CONSUMER_SECRET', 'VXovfMbNcXkb0gZNP84EsOWITy45jN130padwVIHn3PvP0GRpP');

// 認証した際に飛ぶページ
define('CALLBACK_URL', 'https://wolfnet-twei.sakura.ne.jp/twitter_oauth.php');

//TwitterOAuthのインスタンスを生成し、Twitterからリクエストトークンを取得する
$twitter_connect = new TwitterOAuth(TWITTER_API_KEY, TWITTER_API_SECRET);
$request_token = $twitter_connect->oauth('oauth/request_token', array('oauth_callback' => CALLBACK_URL));

//リクエストトークンはcallback.phpでも利用するのでセッションに保存する
$_SESSION['oauth_token'] = $request_token['oauth_token'];
$_SESSION['oauth_token_secret'] = $request_token['oauth_token_secret'];

// Twitterの認証画面へリダイレクト
$url = $twitter_connect->url('oauth/authorize', array('oauth_token' => $request_token['oauth_token']));
header('Location: '.$url);
?>