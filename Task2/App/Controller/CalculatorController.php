<?php

namespace App\Controller;

use App\Core\Router;
use App\Modules\Policy;
use App\Core\Validation;

class CalculatorController extends Controller
{
    private $policy_data;
    protected $validation = true;

    public function policy()
    {
        $this->validation = Validation::validate($_POST, [
            'car_value' => [
                'name' => 'Estimated value of the car',
                'required' => true,
                'type' => 'float',
                'min' => 100,
                'max' => 100000,
            ],
            'user_time' => [
                'name' => 'User time',
                'required' => true,
                'type' => 'datetime',
            ],
            'instalments' => [
                'name' => 'Number of instalments',
                'required' => true,
                'type' => 'int',
                'min' => 1,
                'max' => 12,
            ],
            'tax_percentage' => [
                'name' => 'Tax percentage',
                'default' => 0,
                'type' => 'int',
                'min' => 0,
                'max' => 100,
            ],
        ]);

        if ($this->validation === true) {
            $this->policy_data = (new Policy([
                'value' => (float)$_POST['car_value'],
                'tax_percent' => (int)$_POST['tax_percentage'],
                'datetime' => $_POST['user_time'],
            ]))->getInstalments((int)$_POST['instalments']);


            return $this->view('policy', [
                'index_url' => Router::getRoute('calculator.index'),
                'policy_data_table' => $this->policyDataToHtml(),
            ]);
        } else {
            return $this->errorsView();
        }
    }

    public function index()
    {
        return $this->view('calculator', [
            'post_url' => Router::getRoute('calculator.policy'),
        ]);
    }

    private function policyDataToHtml()
    {
        // Ughh.. Hate that part, but time is money
        // Blade, twig - sorry, but vanilla PHP application only...

        $style = 'font-weight: bold; min-width: 100px;';
        // 1st row
        $columns_1_row = $this->view('component/column', [
            'text' => '',
            'style' => $style,
        ])->render();

        // 2nd row
        $columns_2_row = $this->view('component/column', [
            'text' => 'Value',
        ])->render();

        $columns_2_row .= $this->view('component/column', [
            'text' => $this->policy_data['value'] . '€',
        ])->render();

        // 3rd row
        $columns_3_row = $this->view('component/column', [
            'text' => 'Base price',
        ])->render();

        // 4th row
        $columns_4_row = $this->view('component/column', [
            'text' => 'Commission',
        ])->render();

        // 5th row
        $columns_5_row = $this->view('component/column', [
            'text' => 'Tax (' . $this->policy_data['tax'] . '%)',
        ])->render();

        // 6th row - total
        $columns_6_row = $this->view('component/column', [
            'text' => 'Total cost',
            'style' => $style,
        ])->render();

        $i = 0;
        foreach ($this->policy_data['data'] as $key => $policy) {
            // 1st row
            if ($key == 'total') {
                $columns_1_row .= $this->view('component/column', [
                    'text' => 'Policy',
                    'style' => $style,
                ])->render();
            } else {
                ++$i;
                $columns_1_row .= $this->view('component/column', [
                    'text' => $i . ' instalment',
                    'style' => $style,
                ])->render();
            }

            $columns_3_row .= $this->view('component/column', [
                'text' => number_format($policy['base_price'], 2, '.', ' ') . '€',
            ]);

            $columns_4_row .= $this->view('component/column', [
                'text' => number_format($policy['commission'], 2, '.', ' ') . '€',
            ]);

            $columns_5_row .= $this->view('component/column', [
                'text' => number_format($policy['tax'], 2, '.', ' ') . '€',
            ]);

            $columns_6_row .= $this->view('component/column', [
                'text' => number_format($policy['total'], 2, '.', ' ') . '€',
                'style' => $style,
            ]);
        }

        $rows = '';

        for ($i = 1; $i <= 6; ++$i) {
            $column_var = 'columns_' . $i . '_row';

            $rows .= $this->view('component/row', [
                'columns' => $$column_var,
            ])->render();
        }

        return $this->view('component/table', [
            'rows' => $rows,
        ])->render();
    }
}
