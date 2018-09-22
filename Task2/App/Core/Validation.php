<?php

namespace App\Core;

use App\Core\Exceptions\ValidatorException;

class Validation
{
    protected $data;
    protected $error_messages = [];

    public static function validate(&$data, $validation_rules)
    {
        $instance = (new self);
        $instance->data = $data;

        foreach ($validation_rules as $input_name => $input_rules)
        {
            $validator_property = $input_rules['type'] . 'Validator';
            $validator_object = 'App\Core\Validators\\' . ucfirst($input_rules['type']) . 'Validator';

            if (class_exists($validator_object)) {
                $instance->$validator_property = (new $validator_object($input_name, $instance->data[$input_name], $input_rules['name'] ?? $input_name));
            } else {
                throw new ValidatorException($validator_object . ' class is missing.');
            }

            if (isset($input_rules['required']) && $input_rules['required']) {
                $instance->validateRequired($input_name, $input_rules['name'] ?? $input_name);
            }

            if (isset($input_rules['default']) && mb_strlen($input_rules['default']) !== 0 && (! isset($instance->data[$input_name]) || (isset($instance->data[$input_name]) && mb_strlen($instance->data[$input_name]) === 0))) {
                $instance->data[$input_name] = $instance->$validator_property->setDefault($input_rules['default']);
            }

            unset($input_rules['required'], $input_rules['default'], $input_rules['name']);

            foreach ($input_rules as $input_rule => $input_rule_expectation)
            {
                if ($instance->inputHasError($input_name)) {
                    break;
                } else {
                    $validation_method = 'validate' . ucfirst($input_rule);

                    $result = $instance->$validator_property->$validation_method($input_rule_expectation);


                    if (count($result)) {
                        $instance->mergeErrorMessages($result);
                    }
                }
            }
        }

        $data = $instance->data;

        if (count($instance->error_messages)) {
            return $instance->error_messages;
        }

        return true;
    }

    /**
     * @param string $input_name
     * @param string $input_name_human
     * @return array
     */
    protected function validateRequired(string $input_name, string $input_name_human): array
    {
        if ((isset($this->data[$input_name]) && ! trim($this->data[$input_name])) || (! isset($this->data[$input_name]))) {
            return $this->setErrorMessage($input_name, $input_name_human, 'is required field');
        }

        return [];
    }

    /**
     * @param string $input_name
     * @param string $input_name_human
     * @param string $error_message
     * @return array
     */
    protected function setErrorMessage(string $input_name, string $input_name_human, string $error_message): array
    {
        $this->error_messages[$input_name] = $input_name_human . ' ' . $error_message;

        return $this->error_messages;
    }

    /**
     * @param array $new_error_messages
     * @return array
     */
    protected function mergeErrorMessages(array $new_error_messages): array
    {
        $this->error_messages = array_merge($this->error_messages, $new_error_messages);

        return $this->error_messages;
    }

    /**
     * @param $input_name
     * @return bool
     */
    protected function inputHasError($input_name): bool
    {
        if (isset($this->error_messages[$input_name])) {
            return !! mb_strlen(trim($this->error_messages[$input_name]));
        }

        return false;
    }
}
