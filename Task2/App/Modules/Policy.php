<?php

namespace App\Modules;

use Exception;
use DateTime;

class Policy
{
    /**
     * Required keys: value, tax_percent, datetime
     *
     * @var array
     */
    protected $data;

    protected $base_price_percent = 11;
    protected $commission_percent = 17;

    protected $base_price;
    protected $commission;
    protected $tax;

    protected $instalments = 1;
    protected $instalment_data = [
        'value' => 0,
        'tax' => 0,
        'data' => [],
    ];

    public function __construct(array $data = [])
    {
        $this->data = $data;
    }

    public function getInstalments(int $instalments_count): array
    {
        return $this->getBasePrice()
            ->getCommission()
            ->getTax()
            ->setInstalments($instalments_count)
            ->calculateInstalments();
    }

    protected function calculateInstalments(): array
    {
        $data = [
            'total' => [
                'base_price' => $this->base_price,
                'commission' => $this->commission,
                'tax' => $this->tax,
                'total' => round($this->base_price + $this->commission + $this->tax, 2),
                'balance_left' => 0,
            ],
        ];

        $data['total']['balance_left'] = $data['total']['total'];

        if ($this->instalments > 1) {
            $total = 0;

            $payments_left = $this->instalments;
            $base_price = $this->base_price;
            $commission = $this->commission;
            $tax = $this->tax;

            for ($i = 1; $i <= $this->instalments; ++$i) {
                $base_price_instalment = round($base_price / $payments_left, 2);
                $commission_instalment = round($commission / $payments_left, 2);
                $tax_instalment = round($tax / $payments_left, 2);

                $data_total = (float)round($base_price_instalment + $commission_instalment + $tax_instalment, 2);
                $data_total_key = (string) $data_total . '_' . $i;

                $data[$data_total_key] = [
                    'base_price' => (float)$base_price_instalment,
                    'commission' => (float)$commission_instalment,
                    'tax' => (float)$tax_instalment,
                    'total' => $data_total,
                    'balance_left' => 0,
                ];

                $total = round($total + $data[$data_total_key]['total'], 2);

                $data[$data_total_key]['balance_left'] = (float)round($base_price + $commission + $tax, 2);

                $base_price = round($base_price - $base_price_instalment, 2);
                $commission = round($commission - $commission_instalment, 2);
                $tax = round($tax - $tax_instalment, 2);

                --$payments_left;
            }
        }

        krsort($data);

        $this->instalment_data['data'] = $data;

        $this->instalment_data['value'] = (float)$this->value;
        $this->instalment_data['tax'] = (int)$this->tax_percent;

        return $this->instalment_data;
    }

    protected function getBasePrice(): Policy
    {
        // Base price of policy is 11% from entered car value, except every Friday 15-20 o’clock (user time) when it is 13%
        if ($this->datetime->format('w') == 5) {
            if ((int)$this->datetime->format('H') >= 15 && (int)$this->datetime->format('H') <= 20) {
                $this->base_price_percent = 13;
            }
        }

        $this->base_price = round($this->value * ($this->base_price_percent / 100), 2);

        return $this;
    }

    protected function getCommission(): Policy
    {
        $this->commission = round($this->base_price * ($this->commission_percent / 100), 2);

        return $this;
    }

    protected function getTax(): Policy
    {
        $this->tax = round($this->base_price * ($this->tax_percent / 100), 2);

        return $this;
    }

    protected function setInstalments($instalments_count): Policy
    {
        $this->instalments = $instalments_count;

        return $this;
    }

    /**
     * @param $name
     * @return DateTime|mixed
     * @throws Exception
     */
    public function __get($name)
    {
        if (isset($this->data[$name])) {
            if ($name == 'datetime') {
                return (new DateTime($this->data[$name]));
            }

            return $this->data[$name];
        }

        throw new Exception('Property "' . $name . '" is not defined (Class ' . __CLASS__ . ')');
    }

    /**
     * @param $name
     * @param $value
     */
    public function __set($name, $value)
    {
        if (isset($this->data[$name])) {
            $this->data[$name] = $value;
        }
    }
}
