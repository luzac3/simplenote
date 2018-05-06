$(document).ready(function(){
    //バルーン等Hide処理
    $(".hide").hide();

    // 戻るボタンで戻った場合に値を戻す処理
    if(storager.check("register")){
        let register = storager.get("register");
        //値をセット
        let c_register = $(".c_register");

        //フォームのオブジェクトのValueを取得
        //ラジオボタン取得用のkeyを設定
        // 数の増えたボックスの設定を考える必要有
        let key ="";
        for(let i=0,len=c_register.length; i<len; i++){
            key = $(c_register[i]).attr("id");
            if($("#"+key)[0].value === undefined){
                $("input[name='"+key+"']").val([register[key]]);
            }else{
                $("#"+key).val(register[key]);
            }
        }
    }

    //セッション破棄(30分)
    setTimeout(function(){
        storager.delete();
        storager.set("timeout",0);
    },30*60*1000)

    storager.set("timeout",1);
    try {
        fn_register();
    } catch (e){
        location.href = "./register_failue.html";
    }
});

function fn_register(){
    $(".PRT_NAME").on("change",function(){
    	// 変更された枠名
        let prt_name = $(this).val();

        // 枠名のリスト
        let prt_name_list = $(".PRT_NAME").val();

        // インデックス番号から項目番号を取得する
        let prt_num = prt_name_list.indexOf(prt_name_obj);

        // 枠名を持つチェックボックスを全て収集
        let prt_num_list = $(".PRT_NUM");

        // 書き換えるインデックスを入れるリストを宣言
        let input_list = null;
        prt_num_list.forEach(function(prt_num_object){
            input_list = prt_num_object.find("input");
            input_list[prt_num].text(prt_name);
        });
    });

    $('button').on('click',function(){
        let button_val = $(this).val();

        // 押下したボタンをDisabledに変更
        $(this).prop("disabled",true);
        // 5秒後にボタンを復帰する
        let kill_button = setTimeout(function(){
            $(this).prop("disabled",false);
        }.bind(this),3*1000)

        if(button_val == "register_button"){

            let trk_num = $("#main").prop("class").split(" ")[0];

            let grp_num =  $("#main").prop("class").split(" ")[1];
            if(grp_num == "no_grp"){
                // グループが存在しない場合はグループ登録番号がNULL
                grp_num = null;
            }else{
                // グループが存在する場合は登録番号がNULL
                trk_num = null;
            }

            // 登録処理開始
            // マスタ登録用
            let register={};

            // トランザクション登録用
            let register_transact = {};
            // トランザクションのカラム一時保存用
            let clmn_transact = {};
            // トランザクションのキー配列保存用
            let clmn_key = [];

            // 値の設定されたクラスのオブジェクトを取得
            let c_register = $(".c_register");

            // カラム名のkeyを設定
            let key ="";

            // 複数項目を持つ場合の、テーブル名変更検知用
            let table_name = "";

            for(let i=0,len=c_register.length; i<len; i++){
                if($(c_register[i]).attr("id")){
                    key = $(c_register[i]).attr("id");
                    register[key] = $("#"+key).val()
                }else{
                    table_name = $(c_register[i]).closest("tr").attr("id");
                    key = $(c_regisger[i]).attr("class").split(" ")[1];

                    // カラムリストの設定
                    clmn_key.push(key);

                    clmn_transact[key] = [];

                    let num = 0;
                    // カラム名が変わるまでリピート
                    while($(c_register[i]) && key != $(c_register[i]).attr("class").split(" ")[1]){
                        // 項目順に配列に挿入
                        register_transact[table_name][num] = [];

                        // 選択されたinputのリスト
                        let prt_num_list = $(c_register[i]).closest("tr").find("input[name='"+table_name+"']:checked");

                        // 選択された枠数分ループ
                        prt_num_list.forEach(function(prt_num){
                            // 通番用に0番目は空ける
                            register_transact[table_name][num].push("");

                            // 番号を設定する。1番から開始のため、＋1する
                            register_transact[table_name][num].push(num + 1);

                            // 枠番号を設定
                            register_transact[table_name][num].push(prt_num.val());

                            // 呼ばれた順に[番号][カラム順]で配列に登録
                            register_transact[table_name][num].push($("#"+key).val());
                            num++;
                        })
                        i++;
                    }
                }
            }

            storager.set("register",register);
            console.log(register);
            console.log(JSON.stringify(register));
            storager.set("register_transact",register_transact);
            console.log(register_transact);
            console.log(JSON.stringify(register_transact));

            // 配列の文字列化処理(登録画面遷移用)
            let confirm = JSON.stringify(register);
            let confirm_transact = JSON.stringify(register_transact);

            location.href = "./plan_confirm.html?register="+encodeURIComponent(encodeURIComponent(confirm))
                                             + "?register_transact="+encodeURIComponent(encodeURIComponent(confirm_transact));
        }else{
            if(button_val = "add"){
                // クリックされた場所から、コピー用のオブジェクトを取得
                let origin_obj = $(this).closest("td").find(".clone").filter(":last");

                // コピーしたオブジェクトを直後に挿入
                origin_obj.clone().insertAfter(origin_obj);

                if($(this).closest("tr").prop("id") == "PRT"){
                    // コピー後のオブジェクト数を取得
                    let obj_num = $(this).closest("td").find(".clone").length;

                    // 枠数を持つ全てのオブジェクトを取得
                    let origin_list = $(".PRT_NUM");

                    first_flag = true;
                    Array.from(origin_list).forEach(function(obj){
                        if(obj_num == 2 && first_flag){
                            // 最初のオブジェクトであれば、隠れたinputのhiddenを削除
                            $(obj).find("input").filter(":last").removeClass("hidden");
                            first_flag = false;
                        }
                        // 枠数を持つオブジェクトの中で、最後のinput要素を複製
                        change_obj = $(obj).find("input").filter(":last").clone();
                        // 付随するラベル(枠名)も複製
                        change_label = $(obj).find("label").filter(":last").clone();

                        change_obj.val(obj_num);
                        change_label.text("枠"+obj_num);
                        $(obj).find("label").filter(":last").after(change_label).after(change_obj);

                        // obj.find(":last").val(obj_num);
                    })
                    // 削除キーのDisabledを解除
                    $(this).next("button").prop("disabled",false);
                }
            }else if(button_val = "del"){
                // 最後の要素を削除する
                $(this).closest("td").find(".clone").filter(":last").remove();

                // タイムアウトを消す
                clearTimeout(kill_button);
                if($(this).closest("td").find(".clone").length < 2){
                    // 要素を削除して2より小さくなったらボタンをDisabledにする
                    $(this).next("button").prop("disabled",true);
                }
            }
        }
	});
}

function fnsession(){
    let bool = true;
    let tf = function(set_bool){
        bool === undefined ? bool : set_bool;
        return bool;
    }
    return tf;
}