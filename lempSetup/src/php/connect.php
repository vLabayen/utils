<?php

try {
	$pdo = new PDO(
		"mysql:host=localhost;dbname=##DBNAME##",
		"php",
		"##PHPPASSWORD##"
	);
} catch (PDOException $e) {
	die(json_encode(array("error" => "error while connecting to the database")));
}

?>
