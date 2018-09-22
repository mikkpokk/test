<?php

namespace App\Core;

class Application extends Router
{
    /**
     * Application constructor.
     */
    public function __construct()
    {
        $this->route();
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->render();
    }
}
