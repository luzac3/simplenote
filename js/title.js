$(document).ready(function(){
	// 新規作成をクリック
    $("#new").on("click",function(){
        let url = location.href;

        let layer = location.href.split("/");
        let layer2 = layer[layer.length - 1];

        url = url.replace(layer2,"content.html");

        // 新規作成ボタンに紐づくコード値を取得
        let cd = $(this).prop("class").split("_");

        // 所属コード
        let shzk_cd = cd[0];
        // コンテンツ番号
        let content_num = cd[1];

        // 所属コードを文字列化
        shzk_cd = shzk_cd.toString(10);

        if(parseInt(++content_num,10) < 10){
            // コンテンツ通番が10より小さい場合は0をつけたうえで文字列化
            content_num = "0" + content_num.toString(10);
        }else{
            // それ以外の場合はそのまま文字列化
            content_num = content_num.toString(10);
        }

        (function(){
            // コンテンツ新規作成用の即時関数
        })
        //Ajaxで新規作成した後、コールバックでIDを取得して編集に飛ばす
        location.href = url + "?id=" + id + "&category=edit";
    });

    // コンテンツをクリック
    $("#show a").on("click",function(){
        // タイトル通番を取得
        let title_serial_num = $(this).prop("class");

        let url = location.href;

        let layer = location.href.split("/");
        let layer2 = layer[layer.length - 1];

        // コンテンツページ
        url = url.replace(layer2,"content.html");

        // コンテンツページに遷移
        location.href = url + "?id=" + title_serial_num;
    });

    // コンテンツメニューをクリック
    $("#menu a").on("click",function(){
        // 編集の種類を取得
        let kind = $(this).prop("class").split(" ")[0];
        // カテゴリーを取得
        let category = $(this).prop("class").split(" ")[1];
        // コンテンツ通番を取得
        let num = $(this).prop("class").split(" ")[2];

        let layer = location.href.split("/");
        let layer2 = layer[layer.length - 1];

        // ここでのEditは削除とタイトル変更のみ(phase1)
        // phase2以降はグループ編集などの項目が入る

    });


});