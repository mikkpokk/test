<?php

spl_autoload_register(function ($class) {
    $filename = realpath(dirname(__FILE__)) . '/' . str_replace('\\', '/', $class) . '.php';

    if (file_exists($filename)) {
        require_once($filename);
    }
});
