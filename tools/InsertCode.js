// 功能：将代码从.m文件读出插入到网页中
// 使用说明：代码会放到div中，该div的class='codeDiv'，id='codeX'，X代表1，2，3……
//         代码文件（.m）文件的命名也必须是code1.m,code2.m,....

// var __FILE__, scripts = document.getElementsByTagName("script"); 
// __FILE__ = scripts[scripts.length - 1].getAttribute("src");

// http://www.mczone.com.cn 
// http://localhost/MyWebsite
function insertCode(filePath){
    var codeDivs = document.all ? document.all : document.getElementsByTagName('div');
    for ( var i = 0; i < codeDivs.length; i++ ) {
        var oneCodeDiv = codeDivs[i]
        if (oneCodeDiv.className == 'codeDiv') {
            var divId = oneCodeDiv.id;
            var codeAddr = filePath+divId+'.m'
            $.ajax({
                type: 'GET',
                url : 'http://www.mczone.com.cn/tools/FormateCode.php',
                data : {
                    "filePath" : codeAddr,
                    "divId"    : divId,
                },
                dataType : 'json',
                cache : false,
                success : function(data) {
                    var div = document.getElementById(data['divId'])      
                    div.innerHTML = data['htmlStr']
                    //获取数据后必须调用这个方法
                    fixCodeColor()
                },
                error: function(data){
                    alert("load error")
                }
            });
        }
    } 
}

