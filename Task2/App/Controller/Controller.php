<?php

namespace App\Controller;

use App\Core\Abstracts\View;
use App\Core\Router;

abstract class Controller extends View
{
    protected $validation = true;

    protected function errorsView()
    {
        $output =  '';
        if (is_array($this->validation)) {
            foreach ($this->validation as $error_message)
            {
                $output .= $this->view('component/error', [
                    'message' => $error_message,
                ])->render();
            }
        }

        return $this->view('errors', [
            'index_url' => Router::getRoute('calculator.index'),
            'back_text' => 'Back to calculator',
            'output' => $output,
        ]);
    }
}
