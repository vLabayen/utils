<?php
header('Content-Type: application/json');
include_once("/var/ww/html/connect.php");
die(json_encode(array("uri" => $_SERVER['REQUEST_URI'])));
?>