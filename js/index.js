$(document).ready(function(){
    // タイトルをクリック
    $("#titles a").on("click",function(){
        // タイトルのIDを取得
        let id = $(this).prop("id");
        let url = location.href;

        let layer = location.href.split("/");
        // 現在の階層のURLを取得
        let layer2 = layer[layer.length - 1];

        // URLを変更
        url = url.replace(layer2,"title.html");

        // 取得したIDのコンテンツページに遷移
        location.href = url + "?id=" + id;
    });
});