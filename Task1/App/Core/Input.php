<?php

namespace App\Core;

class Input
{
    /**
     * @var string
     */
    protected $name;
    /**
     * @var string
     */
    protected $proceeded_name;

    /**
     * Input constructor.
     * @param string $name
     */
    public function __construct(string $name)
    {
        $this->name = $name;
    }

    /**
     * @return string
     */
    public function convertNameToLatin(): string
    {
        $string = $this->name;

        if (strpos($string = htmlentities($string, ENT_QUOTES, 'UTF-8'), '&') !== false) {
            $string = html_entity_decode(preg_replace('~&([a-z]{1,2})(?:acute|cedil|circ|grave|lig|orn|ring|slash|tilde|uml);~i', '$1', $string), ENT_QUOTES, 'UTF-8');
        }

        return $string;
    }

    /**
     * @param string $name
     * @return string
     */
    public function uppercaseNames(string $name): string
    {
        return mb_convert_case(mb_strtolower($name), MB_CASE_TITLE, "UTF-8");
    }

    /**
     * @param string $name
     * @return Object
     */
    protected function setProceededName(string $name): Object
    {
        $this->proceeded_name = $this->uppercaseNames($name);

        return $this;
    }

    /**
     * @param string|null $method_name
     */
    protected function printOut(string $method_name = null): void
    {
        if (!$method_name) {
            $method_name = __FUNCTION__;
        }

        echo 'Printing name using ' . $method_name . ' method: ',
        '<b>',
        $this->proceeded_name,
        '</b><br>';
    }
}
