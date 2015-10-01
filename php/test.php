<?php
header("Content-type:text/html;charset=utf-8");

print_r($_GET);
 return;
echo "<code>";
//此处的文件名需要根据传来的参数改动
$fileName = "./AppDelegate.m";
$file = fopen($fileName, "r");
while(!feof($file)) {
  $str = fgets($file);
  $str1 = annotateSingleLine($str);
  if(strlen($str) == strlen($str1)){
  	$str1 = findParameter($str1);
  	$str1 = findKeyword($str1);
  }
  echo $str1;
}
fclose($file);
echo "</code>";

//单行注释
function annotateSingleLineRegular($matches){
  $str = '<span id="spanAnnotate">'.$matches[0].'</span>';
  if (count($matches[0]) > 0) {
    $isContiune = FALSE;
  }
  return $str;
}
function annotateSingleLine($str){
  return preg_replace_callback("#\/\/.*#","annotateSingleLineRegular",$str);
}

//参数和返回值
function findParameterRegular($matches){
  return preg_replace_callback("#\w*[ ]*[*]*#",function($matches){
            return '<span id="spanParam">'.$matches[0].'</span>';
        }, $matches[0]);
}
function findParameter($str){
  return preg_replace_callback("#\([ ]*\w+[ ]*[*]*[ ]*\)#","findParameterRegular", $str);
}


//关键字
function findKeywordRegular($matches){
  return '<span id="spanKeyword">'.$matches[0].'</span>';
}
function findKeyword($str){
  return preg_replace_callback("#\bself\b|\bsuper\b#","findKeywordRegular", $str);
}

?> 