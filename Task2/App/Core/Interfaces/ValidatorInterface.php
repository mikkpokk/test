<?php

namespace App\Core\Interfaces;

interface ValidatorInterface
{
    /**
     * ValidatorInterface constructor.
     * @param string $input_name
     * @param string $input
     * @param string $input_name_human
     */
    public function __construct(string $input_name, string $input, string $input_name_human);

    /**
     * @return array
     */
    public function validateType(): array;

    /**
     * @param mixed $amount
     * @return array
     */
    public function validateMin($amount): array;

    /**
     * @param mixed $amount
     * @return array
     */
    public function validateMax($amount): array;

    /**
     * @param $default
     * @return array
     */
    public function setDefault($default);

}
