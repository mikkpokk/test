<?php

namespace App\Core\Validators;

use App\Core\Interfaces\ValidatorInterface;
use App\Core\Abstracts\Validation;
use DateTime;

class DatetimeValidator extends Validation implements ValidatorInterface
{
    /**
     * @return array
     */
    public function validateType(): array
    {
        if (! $this->verifyDate($this->input)) {
            return $this->setErrorMessage('is not DateTime (Format: Y-m-d H:i:s).');
        }

        return [];
    }

    private function verifyDate($date, $strict = true)
    {
        $dateTime = DateTime::createFromFormat('Y-m-d H:i:s', $date);
        if ($strict) {
            $errors = DateTime::getLastErrors();
            if (!empty($errors['warning_count'])) {
                return false;
            }
        }
        return $dateTime !== false;
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
            $this->input = date('Y-m-d H:i:s', strtotime($value));
        }

        return $this->input;
    }
}
