<?php
header('Content-Type: application/json');
include_once("/var/www/html/connect.php");
die(json_encode(array("uri" => $_SERVER['REQUEST_URI'])));
?>
