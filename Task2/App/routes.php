<?php

$this->get('/', ['uses' => 'CalculatorController@index'])
    ->name('calculator.index');
$this->post('/?get_policy', ['uses' => 'CalculatorController@policy'])
    ->name('calculator.policy');
