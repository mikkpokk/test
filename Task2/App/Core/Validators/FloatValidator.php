<?php

namespace App\Core\Validators;

use App\Core\Interfaces\ValidatorInterface;
use App\Core\Abstracts\Validation;

class FloatValidator extends Validation implements ValidatorInterface
{
    /**
     * @return array
     */
    public function validateType(): array
    {
        if (! is_numeric($this->input)) {
            return $this->setErrorMessage('is not float.');
        }

        return [];
    }

    /**
     * @param int $amount
     * @return array
     */
    public function validateMin(int $amount): array
    {
        if ((float) $this->input < $amount) {
            return $this->setErrorMessage('minimum allowed value is ' . $amount);
        }

        return [];
    }

    /**
     * @param int $amount
     * @return array
     */
    public function validateMax(int $amount): array
    {
        if ((float) $this->input > $amount) {
            return $this->setErrorMessage('maximum allowed value is ' . $amount);
        }

        return [];
    }

    /**
     * @param $value
     * @return mixed
     */
    public function setDefault($value)
    {
        if ($this->input === '') {
            $this->input = (float) $value;
        }

        return $this->input;
    }
}
