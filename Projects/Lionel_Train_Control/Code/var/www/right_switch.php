<?php

$file = fopen("test.txt","w") or die("Unable to open file!");
echo fwrite($file,"1");
fclose($file);


header('Location: index.php');
?>


<html>
<body>


<?php
$file = fopen("test.txt","w") or die("Unable to open file!");
echo fwrite($file,"1");
fclose($file);
?>

<form action="left_switch.php" method="post">
<input type="submit">
</form>
<form action="right_switch.php" method="post">
<input type="submit">
</form>


</body>
</html>


