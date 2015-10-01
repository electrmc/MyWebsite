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