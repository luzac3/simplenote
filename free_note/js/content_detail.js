$(document).ready(function(){
    // コンテンツをクリック
    $("button").on("click",function(){
        // コンテンツ内番号を取得
        let kind = $(this).val();

        let url = location.href;

        switch(kind){
            case "edit":
              url = url + "&category="+kind;
              location.href = url;
              break;
            case "save":
              // 編集したコンテンツを取得
              let content = $("#content textarea").val();

              let serial = $("#content").prop("class").split(" ")[0];

              let trk_num = $("#content").prop("class").split(" ")[1];

              let arg_arr = {
                  cntnt_serial_num:serial
                  ,trk_num:trk_num
                  ,content:content
              }
              call_stored("content_edit_001",arg_arr).then(
                  function(data){
                      // 成功
                      console.log("作成完了");
                      // リロード
                      location.reload();
                  },function(error){
                      console.log(error);
                  }
              );
        }
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
});