<?php
  $result = shell_exec ('/var/www/html/cfgraph/create.sh ' . $_POST['name'] . ' ' . $_POST['pswd']);
  header('Location: '.$_POST['name'] . '/out.jpg'); 
?>