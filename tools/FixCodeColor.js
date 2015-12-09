/*
 * 使用说明：此处的className必须域Formate.php中命名相同
 */
;function fixCodeColor(){
	var annotateSpan = document.getElementsByClassName("spanAnnoate");
	for (var i = 0; i < annotateSpan.length; i++) {
	    annotateSpan[i].style.color = "#007400";//绿色
	}

	var keywordSpan = document.getElementsByClassName("spanKeyword");
	for (var i = 0; i < keywordSpan.length; i++) {
	    keywordSpan[i].style.color = '#FF0000'; //红色
	}

	var paramSpan = document.getElementsByClassName("spanParam");
	for (var i = 0; i < paramSpan.length; i++) {
	    paramSpan[i].style.color = '#FF0000';//红色
	}
}

/*
 * 使用说明：修改div的边框 该方法暂时未用到
 */
function fixCodeDivStyle(codeDiv){
    codeDiv.style.borderColor = "black";
    codeDiv.style.borderWidth = "2px";
    codeDiv.style.borderStyle = "solid";
}

/*
 * 使用说明：html中需要插入代码的地方把div的class命名为"codeDiv"，id名随便，只要在js中可以得到
 */
function fixAllCodeDivStyle(){
	alert('1');
	var codeDiv = document.getElementsByClassName("codeDiv");
	for (var i = 0; i < codeDiv.length; i++) {
	    codeDiv[i].style.borderColor = "black";
	    codeDiv[i].style.borderWidth = "2px";
	    codeDiv[i].style.borderStyle = "solid";
	}
}