$(document).ready(function(){
	$("#contents a").on("click",function(){
		let category = $(this).prop("class").split(" ")[0];
		let num = $(this).prop("class").split(" ")[1];

		let layer = location.href.split("/");
		let layer2 = layer[layer.length - 1];

		url = url.replace(layer2,"content.html");

		location.href = url + "?id=" + id + "&category=" + category;
	});

	$("#new").on("click",function(){

		let category = $(this).prop("class").split(" ")[0];
		let num = $(this).prop("class").split(" ")[1];

		let layer = location.href.split("/");
		let layer2 = layer[layer.length - 1];

		url = url.replace(layer2,"content.html");

		let cd = $(this).prop("class").split("_");
		let shzk_cd = cd[0];
		let content_num = cd[1];

		shzk_cd = shzk_cd.toString(10);

		if(parseInt(++content_num,10) < 10){
			content_num = "0" + content_num.toString(10);
		}else{
			content_num = content_num.toString(10);
		}

		//Ajaxで新規作成した後、コールバックでIDを取得して編集に飛ばす
		location.href = url + "?id=" + id + "&category=edit";
	});
});