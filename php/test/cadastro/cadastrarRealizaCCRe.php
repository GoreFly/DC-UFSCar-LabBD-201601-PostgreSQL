<?php include '../info.php'; ?>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>BD</title>

  <!--[if IE 6]><link href="default_ie6.css" rel="stylesheet" type="text/css" /><![endif]-->

</head>
<body>
	<a href="../index.php"> <- Voltar</a>
	<h1>Cadastrar Conselho de Curso x Reunião </h1>
	<form method="POST" action="../controlador.php">

		<label>Conselho de Curso</label></br>
		<select name="conselhoCurso" required>
			<?php
				$result = getConselhoCurso();
				while ($row = pg_fetch_array($result)) {
     				?>
     				<option value="<?php echo $row['id']; ?>"><?php echo $row['representante']; ?></option>
     				<?php
   				}
			 ?>
		</select></br>

		<label>Reunião</label></br>
		<select name="reuniao" required>
			<?php
				$result = getReuniao();
				while ($row = pg_fetch_array($result)) {
     				?>
     				<option value="<?php echo $row['numero']; ?>"><?php echo $row['numero']; ?></option>
     				<?php
   				}
			 ?>
		</select></br>
		<input name='submit' type="submit" value="Cadastrar RealizarCCRe">
	</form>
</body>
</html>