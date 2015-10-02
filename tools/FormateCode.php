<?php
header("Content-type:text/html;charset=utf-8");
#/data/home/qxu1649340070/htdocs/ 服务器端根地址
#/Library/WebServer/Documents/MyWebsite 本地根地址

$htmlStr = "<pre><code>";
$rootPath = dirname(dirname(__FILE__));
//此处的文件名需要根据传来的参数改动
$fileName = $_GET['fileName'];
$fileName = $rootPath.$fileName;
$file = fopen($fileName, "r");
while(!feof($file)) {
  $str = fgets($file);
  $str1 = annotateSingleLine($str);
  if(strlen($str) == strlen($str1)){
  	$str1 = findParameter($str1);
  	$str1 = findKeyword($str1);
  }
  $htmlStr .= "$str1";
}
fclose($file);
$htmlStr .="</code></pre>";
echo $htmlStr;

//------------------------------单行注释------------------------------
function annotateSingleLineRegular($matches){
  return '<span class="spanAnnoate">'.$matches[0].'</span>';
}
function annotateSingleLine($str){
  return preg_replace_callback("#\/\/.*#","annotateSingleLineRegular",$str);
}

//------------------------------参数和返回值------------------------------
function findParameterWord($matches){
  return '<span class="spanParam">'.$matchess[0].'</span>';
}
function findParameterRegular($matches){//在阿里云服务器上不能支持匿名函数？
  return preg_replace_callback("#\w*[ ]*[*]*#","findParameterWord", $matches[0]);
}
function findParameter($str){
  return preg_replace_callback("#\([ ]*\w+[ ]*[*]*[ ]*\)#","findParameterRegular", $str);
}


//------------------------------关键字------------------------------
function findKeywordRegular($matches){
  return '<span class="spanKeyword">'.$matches[0].'</span>';
}
function findKeyword($str){
  return preg_replace_callback("#\bself\b|\bsuper\b|\breturn\b#","findKeywordRegular", $str);
}

?> 