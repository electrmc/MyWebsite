<?php
header("Content-type:text/html;charset=utf-8");

$htmlStr = "<pre><code>";
//此处的文件名需要根据传来的参数改动
$fileName = $_GET['fileName'];
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
function findParameterRegular($matches){
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