$(document).ready(function(){
    // コンテンツをクリック
    $("#content_list a").on("click",function(){
        // コンテンツ内番号を取得
        let serial = $(this).prop("id");

        let layer = location.href.split("/");
        let layer2 = layer[layer.length - 1];

        let url = location.href;

        // コンテンツ詳細ページ
        url = url.replace(layer2,"content_detail.html");

        // コンテンツの詳細ページに遷移
        location.href = url + "?id=" + serial;
    });

	// 投稿をクリック
    $("#send").on("click",function(){
        // 新規作成ボタンに紐づくコード値を取得
        let new_content = $("#new_content textarea").val();

        let serial = $("#content_list").prop("class").split(" ")[0];

        let trk_num =  $("#content_list").prop("class").split(" ")[1];

        let arg_arr = {
            title_serial_num:serial
            ,trk_num:trk_num
            ,cntnt:new_content
            ,_rep_cd:"0"
            ,_rep_no:""
            ,_rep_no2:""
        }

        call_stored("new_content_001",arg_arr).then(
            function(data){
                // 成功
                console.log("作成完了");
                // リロード
                location.reload();
            },function(error){
                console.log(error);
            }
        );
    });
});