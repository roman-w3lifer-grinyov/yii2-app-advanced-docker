<?php

const PATH_TO_DB_CONFIG = 'common/config/main-local.php';

$config = file_get_contents(PATH_TO_DB_CONFIG);

$config = preg_replace('=host\=localhost=', 'host=mysql', $config);
$config = preg_replace('=dbname\=yii2advanced=', 'dbname=' . getenv('MYSQL_DATABASE'), $config);

$config = preg_replace("='username' \=> 'root'=", "'username' => '" . getenv('MYSQL_USER') . "'", $config);
$config = preg_replace("='password' \=> ''=", "'password' => '" . getenv('MYSQL_PASSWORD') . "'", $config);

file_put_contents(PATH_TO_DB_CONFIG, $config);

// ---------------------------------------------------------------------------------------------------------------------

uncommentUrlManager('frontend/config/main.php');
uncommentUrlManager('backend/config/main.php');

function uncommentUrlManager(string $pathToConfig): void
{
    $config = file_get_contents($pathToConfig);

    $config = preg_replace("=/\*\s+?(')=", '$1', $config);
    $config = preg_replace("=\s+?\*/=", '', $config);

    file_put_contents($pathToConfig, $config);
}
