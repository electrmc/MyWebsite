<?php
/*
 * 注意：echo出的内容必须于ajax要求的数据类型匹配，否则就会出错
 * ajax的dataType最好不写，或者是写为text
 */
header("Content-type:text/html;charset=utf-8");
// echo "this msg from php";//ajax要求的数据类型不能是json，至少是html

$str1 = $_GET['flag'];
whatType($str1);

function whatType($data){
	if (isset($data)) {
	echo "this is set";
	}

	if (is_array($data)) {
		echo "this is array";
	}

	if (is_string($data)) {
		echo "this is string";
	}

	if (is_numeric($data)) {
		echo "this is numeric";
	}

	if (is_object($data)) {
		echo "this is object";
	}

	if (is_null($data)) {
		echo "this is null";
	}

	if (is_float($data)) {
		echo "this is float";
	}

	if (is_int($data)) {
		echo "this is int";
	}

	if (is_bool($data)) {
		echo "this is bool";
	}
}

$str1 = (string)$str1;
whatType($str1);

$strTemp = "formJS";
$strTemp1 = 'formJS';


if (strcmp($str1, $strTemp) == 0) {
	echo "double is same";
}
 if(strcmp($str1, $strTemp1) == 0) {
	echo "single is same";
}else{
	echo "na ni";
}
// echo $str1;//单输出$str1时ajax的数据类型可以是json
// echo "get:$str1";//这样输出就不能是json数据类型，如果是html数据类型，那么将会把下面的php语句也会输出

// $str2 = $_POST['flag'];
// echo $str2;

// $str3 = $_REQUEST['flag'];
// echo $str3;

?> 