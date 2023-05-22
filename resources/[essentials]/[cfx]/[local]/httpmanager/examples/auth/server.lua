SetHttpHandler(exports.httpmanager:createHttpHandler {
	templateExtension = "html",
	authorization = {
		["admin"] = "$2a$11$AK6NWflKbeYmnEKfEkUC5uxZ.OPuoJoBPR8yQy5HBIqXxvOpMJwli", -- "password"
		["user"] = "$2a$11$pFxR7jD3/m4XYfkQy9u5LeQ8t0AaSRDNqgV1ih/Zwtq1KY2SMB2kK", -- "password"
	},
	access = {
		{path = "/admin/.*", login = {["admin"] = true}},
		{path = "/public/.*", login = false},
		{path = "/public/secret/.*"}
	},
	routes = {
		["/username"] = function(req, res, helpers)
			res.sendJson{username = req.user}
		end
	}
})
