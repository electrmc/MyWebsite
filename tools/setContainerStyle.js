	//调整container的宽度，以及样式
	window.onresize = setContainerStyle;
	function setContainerStyle(){
		var clientWidth = document.body.clientWidth;
		var container = document.getElementById("container");
		var width = parseInt(clientWidth)*0.8;
		width = width>960?960:width;
		container.style.width = width+"px";

		//container.style.backgroundColor = 'red'; 

		container.style.marginTop = 5+'px';
		container.style.marginBottom = 0;
		container.style.marginLeft = 'auto';
		container.style.marginRight = 'auto';

		container.style.padding = 2+'em';
	}
	setContainerStyle();