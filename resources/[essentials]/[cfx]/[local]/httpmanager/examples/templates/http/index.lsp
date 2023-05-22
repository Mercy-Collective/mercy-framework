<html>
	<head>
		<title>Template example</title>
	</head>
	<body>
		<p><strong>Server time:</strong> ${os.date()}</p>
		<p><strong>Remote address/port:</strong> ${request.address}</p>
		<p><strong>Server name:</strong> ${GetConvar("sv_hostname", "")}</p>
		<p><strong>Players on server:</strong> ${#GetPlayers()}</p>
	</body>
</html>
