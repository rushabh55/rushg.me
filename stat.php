
<?php
// outputs the username that owns the running php/httpd process
// (on a system with the "whoami" executable in the path)
header('Content-type: text/plain');
$output=null;
$retval=null;
$refreshAfter = 3;
header('Refresh: ' . $refreshAfter);
echo 'script 1:';
exec('afterLogin', $output, $retval);
print_r(array_values($output));
exec('zpool status && mpstat -P ALL && df -h  | grep -v /snap', $output, $retval);
echo "Returned with status $retval and output:\n";
print_r(array_values($output)); 
//print_r(json_encode($output, JSON_PRETTY_PRINT));
//print_r($output);
?>
