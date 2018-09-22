<?php

/*
 * Write a simple car insurance calculator which will output price of the policy using vanilla PHP and JavaScript.
 */

require '../autoloader.php';

use App\Core\Application;

try {
    echo new Application();
} catch (Exception $e) {
    echo 'File: ' . $e->getFile() . '<br>';
    echo 'Line: ' . $e->getLine() . '<br>';
    echo 'Code: ' . $e->getCode() . '<br>';
    echo 'Message: ' . $e->getMessage() . '<br>';
}

