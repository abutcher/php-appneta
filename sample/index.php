<html>
<head>
	<title>Hello world!</title>
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<style>
	body {
	background-color: white;
	text-align: center;
	padding: 50px;
	font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	}

	#logo {
	margin-bottom: 40px;
	width: 400px;
	height: 400px;
	}
	</style>
</head>
<body>
	<img id="logo" src="unicorn.gif" />
	<h1><?php echo "Hello ".($_ENV["NAME"]?$_ENV["NAME"]:"world")."!"; ?></h1>
</body>
</html>
