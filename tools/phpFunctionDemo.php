<?php

//---------------------文件路径---------------------
echo __FILE__; // 取得当前文件的绝对地址，结果：/Library/WebServer/Documents/MyWebsite/tools/phpFunctionDemo.php
echo "</br>";
echo dirname(__FILE__); // 取得当前文件所在的绝对目录，结果：/Library/WebServer/Documents/MyWebsite/tools
echo "</br>";
echo dirname(dirname(__FILE__)); //取得当前文件的上一层目录名，结果：/Library/WebServer/Documents/MyWebsite 

//---------------------判断当前数据类型---------------------
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
?>