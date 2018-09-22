<?php

namespace App\Core;

use App\Core\Abstracts\Router as RouterAbstract;

class Router extends RouterAbstract
{
    protected static $route_names;

    /**
     * @param $name
     * @return string
     */
    public static function getRoute($name): string
    {
        return Router::$route_names[$name];
    }

    /**
     * @return mixed
     */
    public static function getRoutes(): array
    {
        return Router::$route_names;
    }

    /**
     * @param $name
     * @return $this
     */
    protected function name($name)
    {
        Router::$route_names[$name] = $this->latest_url;

        return $this;
    }
}