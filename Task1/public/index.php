<?php

/*
 * Task: print out your name with one of php loops
 */

require '../autoloader.php';

use App\Controller\LoopPrinter;

LoopPrinter::setName('mikk')
    ->printFor()
    ->setName('Mikk')
    ->printForeach()
    ->printWhile()
    ->setName('mIkk')
    ->printForeachWhileBrainTeaser();
