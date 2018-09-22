<!DOCTYPE html>
<html>
<head>
    <title>Loan Calculator</title>
</head>
<body>
<div id="form-wrapper">
    <h2>Enter your car loan Details...</h2>
    <form id="calculate-loan" method="post" action="">
        <table>
            <tbody>
            <tr>
                <td><label for="currency">Currency:</label></td>
                <td>
                    <select id="currency" name="currency">
                        <option>$</option>
                        <option>&#8377;</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><label for="vehicle_value">Vehicle Value:</label></td>
                <td><input type="number" id="vehicle_value" name="vehicle_value"></td>
            </tr>
            <tr>
                <td><label for="interest_rate">Interest Rate:</label></td>
                <td><input type="number" min="1" max="100" id="interest_rate" name="interest_rate"></td>
            </tr>
            <tr>
                <td><label for="months">Months:</label></td>
                <td><input type="number" step="1" id="months" name="months"></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" name="submit" value="Submit"></td>
            </tr>
            </tbody>
        </table>
    </form>
</div>
<?php
if(isset($_POST['submit'])) {
    ?>
    <div id="loan-details">
        <h2>Vehicle Loan Repayments By Month</h2>
        <?php
        $balance = (float) $_POST['vehicle_value'];
        $monthly_payment = (($_POST['interest_rate'] /(100 * 12)) * $_POST['vehicle_value']) / (1 - pow(1 + $_POST['interest_rate'] / 1200,  (-$_POST['months'])));
        ?>
        <p>
            Loan Payments: <?php echo $_POST['currency'].number_format($monthly_payment * $_POST['months'], 2); ?><br />
            Monthly Payment: <?php echo $_POST['currency'].number_format($monthly_payment, 2); ?><br />
            Total Interest: <?php echo $_POST['currency'].number_format($monthly_payment * $_POST['months'] - $balance, 2); ?>
        </p>
        <table>
            <tbody>
            <tr>
                <th>Month</th>
                <th>Balance</th>
                <th>Principal</th>
                <th>Interest</th>
                <th>Payment</th>
            </tr>
            <?php
            for($month = 0; $month < (int)$_POST['months']; $month++) {
                $interest = $balance * $_POST['interest_rate'] / 1200;
                $principal = $monthly_payment - $interest;
                ?>
                <tr>
                    <td><?php echo $month + 1 ?></td>
                    <td><?php echo $_POST['currency']. number_format($balance, 2) ?></td>
                    <td><?php echo $_POST['currency']. number_format($principal, 2) ?></td>
                    <td><?php echo $_POST['currency']. number_format($interest, 2) ?></td>
                    <td><?php echo $_POST['currency']. number_format($monthly_payment, 2) ?></td>
                </tr>
                <?php
                $balance -= $principal;
            }
            ?>
            </tbody>
        </table>
    </div>
<?php } ?>
</body>
</html>