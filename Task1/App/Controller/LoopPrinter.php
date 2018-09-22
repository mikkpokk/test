<?php

namespace App\Controller;

use App\Core\Input;

class LoopPrinter extends Input
{
    /**
     * @param string $name
     * @return LoopPrinter
     */
    public static function setName(string $name): LoopPrinter
    {
        return new self($name);
    }

    /**
     * @return LoopPrinter
     */
    public function printForeach(): LoopPrinter
    {
        // Without struggle V1
        $printable_name = '';

        foreach (str_split($this->name) as $letter) {
            $printable_name .= $letter;
        }

        $this->setProceededName($printable_name)
            ->printOut(__FUNCTION__);

        return $this;
    }

    /**
     * @return LoopPrinter
     */
    public function printFor(): LoopPrinter
    {
        // Without struggle V2
        $printable_name = '';

        for ($i = 0; $i < strlen($this->name); ++$i) {
            $printable_name .= $this->name[$i];
        }

        $this->setProceededName($printable_name)
            ->printOut(__FUNCTION__);

        return $this;
    }

    /**
     * @return LoopPrinter
     */
    public function printWhile(): LoopPrinter
    {
        // Without struggle V3
        $name = $this->name;
        $printable_name = '';
        $i = 0;
        while ($name) {
            $printable_name .= $this->name[$i];

            $name = substr($name, 1);

            ++$i;
        }

        $this->setProceededName($printable_name)
            ->printOut(__FUNCTION__);

        return $this;
    }

    /**
     * Prints latin characters only
     *
     * @return LoopPrinter
     */
    public function printForeachWhileBrainTeaser(): LoopPrinter
    {
        $latin_alphabet = (array)array_merge(['-', ' '], range('a', 'z'));
        $original_name = (array)str_split(strtolower($this->convertNameToLatin()));
        $sorted_name = (array)$original_name;
        asort($sorted_name);
        $original_name = $sorted_name;

        $looped_letters = [];

        $i = 0;
        foreach ($latin_alphabet as $character) {
            while (in_array($character, $sorted_name)) {
                $looped_letters[array_keys($original_name)[$i]] = $character;

                array_shift($sorted_name);

                if (count($looped_letters) === count($original_name)) {
                    break;
                }

                ++$i;
            }
        }

        $this->setProceededName(implode('', array_replace(array_keys($original_name), $looped_letters)))
            ->printOut(__FUNCTION__);

        return $this;
    }
}
