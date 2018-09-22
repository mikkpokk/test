<?php

namespace App\Core\Abstracts;

use App\Core\Exceptions\ViewException;
use Exception;

abstract class View
{
    /**
     * @var string
     */
    protected $view = '';

    /**
     * @param string $view
     * @param array $arguments
     * @return $this
     * @throws Exception
     */
    protected function view(string $view, array $arguments = [])
    {
        $this->view = file_get_contents('../Resources/View/' . $view . '.html');

        $layout = $this->getTemplateData('layout');
        if ($layout) {
            $layout = $this->getTemplate($layout);

            foreach ($this->getViewVariables($layout) as $view_variable) {
                $layout = $this->str_replace_first('$' . $view_variable, $this->getTemplateData('layout_' . $view_variable), $layout);
            }

            $this->view = $layout;
        }

        if (count($arguments)) {
            foreach ($arguments as $argument_name => $argument) {
                $this->view = str_replace('$' . $argument_name, $argument, $this->view);
            }
        }

        $undefined_variables = $this->getViewVariables($this->view);
        if (count($undefined_variables)) {
            foreach ($undefined_variables as $undefined_variable) {
                $this->view = $this->str_replace_first('$' . $undefined_variable, '', $this->view);
            }
        }

        return $this;
    }

    /**
     * @return string
     */
    protected function render(): string
    {
        return (string)$this->view;
    }

    /**
     * @param string $tag_name
     * @return string
     */
    protected function getTemplateData(string $tag_name): string
    {
        $pattern = "#<\s*?$tag_name\b[^>]*>(.*?)</$tag_name\b[^>]*>#s";

        preg_match($pattern, $this->view, $matches);

        if (count($matches) > 1) {
            $this->view = trim(preg_replace($pattern, '', $this->view));

            return trim($matches[1]);
        }

        return '';
    }

    /**
     * @param string $view
     * @return string
     * @throws ViewException
     */
    protected function getTemplate(string $view): string
    {
        $view_location = '../Resources/View/' . $view . '.html';

        if (file_exists($view_location)) {
            return file_get_contents($view_location);
        }

        throw new ViewException('Unable to locate <b>Resources/View/' . $view . '.html</b>');
    }

    /**
     * @param string $layout
     * @return array
     */
    protected function getViewVariables(string $layout): array
    {
        if (preg_match_all('/\\$([^\\s\\<\\n\\"\\\']+)/', $layout, $matches)) {
            return $matches[1];
        }

        return [];
    }

    /**
     * @param string $search
     * @param string $replace
     * @param string $subject
     * @return string
     */
    protected function str_replace_first(string $search, string $replace, string $subject): string
    {
        $search = '/' . preg_quote($search, '/') . '/';

        return (string) preg_replace($search, $replace, $subject, 1);
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->render();
    }
}
