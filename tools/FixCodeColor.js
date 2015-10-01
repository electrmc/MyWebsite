function fixCodeColor(){
	var annotateSpan = document.getElementById('spanAnnoate');
	var keywordSpan = document.getElementById('spanKeyword');
	var paramSpan = document.getElementById('spanParam');

	annotateSpan.style.color = '#007400';//绿色
	keywordSpan.style.color = '#FF0000'; //红色
	paramSpan.style.color = '#FF0000';   //红色

}
fixCodeColor();