<?php

namespace App\Core\Abstracts;

use App\Core\Exceptions\RouterException;

abstract class Router extends View
{
    protected $routes = [];
    protected $http_query_variables = [];
    protected $base_url = '';
    protected $callable;
    protected $matching_route = null;
    protected $latest_url = '';

    private $allowed_methods = ['get', 'post', 'any'];

    /**
     * @return $this|string
     * @throws RouterException
     */
    protected function route()
    {
        $this->getBaseUrl();

        include('../App/routes.php');

        if ($this->matching_route !== null) {
            if (is_array($this->callable)) {
                if (! isset($this->callable['class']))
                    throw new RouterException('Callable class missing');

                if (! isset($this->callable['method']))
                    throw new RouterException('Callable method missing');

                $class = $this->callable['class'];
                $method = $this->callable['method'];

                $this->view = (new $class)->$method();
            } else {
                $this->view = $this->callable;
            }

            return $this->render();
        }

        return $this->view('404');
    }

    /**
     * @param string $method
     * @param string $url
     * @param array $params
     * @param callable|null $function
     * @return callable|Object
     * @throws RouterException
     */
    protected function urlHandler(string $method, string $url, array $params = [], callable $function = null)
    {
        $url = trim($url);

        $has_prefix_slash = ($url[0] === '/');

        if ($has_prefix_slash) {
            $url = substr($url, 1);
        }

        $this->latest_url = $url;

        if (($_SERVER['REQUEST_METHOD'] === strtoupper($method) || $method === 'any') && $this->matching_route === null) {
            if (!in_array($method, $this->allowed_methods)) {
                throw new RouterException('Please re-check your routes. Allowed methods are: ' . implode(', ', $this->allowed_methods));
            }

            $http_query_url = $url;
            if (strpos($http_query_url, '?') === 0 || strpos($http_query_url, '&') === 0) {
                $http_query_url = substr($http_query_url, 1);
            }

            parse_str($http_query_url, $http_query_url);

            $match = true;
            foreach ($http_query_url as $key => $value) {
                if (!isset($this->http_query_variables[$key])) {
                    $match = false;

                    break;
                } else {
                    if ($value != '' && $this->http_query_variables[$key] !== $value) {
                        $match = false;

                        break;
                    }
                }
            }

            if ($match) {
                $this->matching_route = $url;

                if (isset($params['uses'])) {
                    $controller_namespace = '\App\Controller\\';
                    $class_name = explode('@', $params['uses']);
                    if (count($class_name) < 2) {
                        throw new RouterException('Missing router controller method ->' . $method . '(' . $url . ', ...)');
                    } else {
                        $method_name = $class_name[1];
                        $class_name = $class_name[0];
                    }

                    $class_name_with_namespace = $controller_namespace . $class_name;

                    $this->callable = [
                        'class' => $class_name_with_namespace,
                        'method' => $method_name,
                    ];
                } elseif (is_callable($function) && $function !== null) {
                    $this->callable = $function;
                } else {
                    throw new RouterException('Missing router callable function and controller ->' . $method . '(' . $url . ', ...)');
                }
            }
        }

        return $this;
    }

    /**
     * @param string $url
     * @param array $params
     * @param callable|null $function
     * @return callable|Object
     * @throws RouterException
     */
    public function any(string $url, array $params = [], callable $function = null)
    {
        return $this->urlHandler(__FUNCTION__, $url, $params, $function);
    }

    /**
     * @param string $url
     * @param array $params
     * @param callable|null $function
     * @return callable|Object
     * @throws RouterException
     */
    public function get(string $url, array $params = [], callable $function = null)
    {
        return $this->urlHandler(__FUNCTION__, $url, $params, $function);
    }

    /**
     * @param string $url
     * @param array $params
     * @param callable|null $function
     * @return callable|Object
     * @throws RouterException
     */
    protected function post(string $url, array $params = [], callable $function = null)
    {
        return $this->urlHandler(__FUNCTION__, $url, $params, $function);
    }

    /**
     * Returns Base URL and if there are $_GET variables in REQUEST_URI then sets those to $http_query_variables as an array
     *
     * @return string
     */
    protected function getBaseUrl(): string
    {
        $base_url = sprintf(
            "%s://%s%s",
            isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https' : 'http',
            $_SERVER['SERVER_NAME'],
            $_SERVER['REQUEST_URI']
        );
        $http_query = '';

        if (strpos($base_url, '?') !== false) {
            $http_query = explode('?', $base_url)[1];

            $base_url = str_replace('?' . $http_query, '', $base_url);
        } elseif (strpos($base_url, '&') !== false) {
            $http_query = explode('&', $base_url)[1];

            $base_url = str_replace('&' . $http_query, '', $base_url);
        }

        parse_str($http_query, $this->http_query_variables);

        $this->base_url = $base_url;

        return $this->base_url;
    }
}
