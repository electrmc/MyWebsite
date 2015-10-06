	
	window.onresize = setContainerStyle;
	var clientWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

	//调整container的宽度，以及样式
	function setContainerStyle(){
		var container = document.getElementById("container");
		var width = parseInt(clientWidth)*0.8;
		width = width>960?960:width;
		container.style.width = width+"px";

		container.style.marginTop = 100+'px';
		container.style.marginBottom = 0;
		container.style.marginLeft = 'auto';
		container.style.marginRight = 'auto';

		container.style.padding = 2+'em';//em是相对于父元素的字体大小设置的，一般来说1em=16px
		container.style.fontSize = "1.5Rem";//Rem是根据body的字体大小设置的
	}
	setContainerStyle();

	/**
	 * /data/home/qxu1649340070/htdocs/ 服务器端根地址
	 * /Library/WebServer/Documents/MyWebsite 本地根地址
	 */

	//设置导航栏
	function setNavbar(){
		var navbar = document.getElementById("navbar");
		navbar.style.width = parseInt(clientWidth)+'px';
		//头像
		var navImage = document.createElement('img');
		navImage.style.cssFloat = "left";
		navImage.style.borderRadius = "40px";
		navImage.style.width = "80px";
		navImage.src = "../image/title.jpg";//js文件是html文件的路径，而非此js文件所在的路径
		navImage.onerror = function(){navImage.src = "./image/title.jpg"};
		var object = navbar.appendChild(navImage);//这里的object就是标签对
		//标题
		var title = document.createElement('p');
		title.style.position = "relative";
		title.style.left = "1em";
		title.style.float = "left";
		title.innerHTML = "苗超的博客，记录路上遇到的点滴";
		navbar.appendChild(title);

		//点击头像或标题返回首页
		navImage.onclick = function(){backToHomepage()};
		navImage.style.cursor= "pointer"; 
	}
	setNavbar();

	function backToHomepage(){
		window.location = "http://localhost/MyWebsite/HomePage/HomePage.html";
	}
