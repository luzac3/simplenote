$(document).ready(function(){
	// 新規作成をクリック
    $("#new").on("click",function(){
        let trk_num = $("#new_title").prop("class").split(" ")[0];
        let shzk_cd = $("#new_title").prop("class").split(" ")[1];
        // タイトル名
        let title = $("#new_title input").val();

        let arg_arr = {
            trk_num:trk_num
            ,shzk_cd:shzk_cd
            ,title:title
        }

        call_stored("new_title_001",arg_arr).then(
            function(data){
                // 成功
                if(data){
                    console.log("作成完了");
                    // リロード
                    location.reload();
                }
            },function(error){
                console.log(error);
            }
        );
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