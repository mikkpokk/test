<?php

namespace App\Core\Abstracts;

abstract class Validation
{
    protected $input_name;
    protected $input;
    protected $input_name_human;
    protected $error_messages = [];

    /**
     * Validation constructor.
     * @param string $input_name
     * @param string $input
     * @param string $input_name_human
     */
    public function __construct(string $input_name, string $input, string $input_name_human)
    {
        $this->input_name = $input_name;
        $this->input = $input;
        $this->input_name_human = $input_name_human;
    }

    /**
     * @param string $error_message
     * @return array
     */
    protected function setErrorMessage(string $error_message): array
    {
        $this->error_messages[$this->input_name] = $this->input_name_human . ' ' . $error_message;

        return $this->error_messages;
    }

    /**
     * @return string
     */
    public function getInput()
    {
        return (string) $this->input;
    }
}
