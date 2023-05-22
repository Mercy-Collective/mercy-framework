SetHttpHandler(exports.httpmanager:createHttpHandler {
	routes = {
		["^/password/generate%-hash$"] = function(req, res, helpers)
			req.readJson():next(function(data)
				local p = promise.new()

				if data.password then
					p:resolve(data.password)
				else
					p:reject("No password in the request data")
				end

				return p
			end):next(function(password)
				res.writeHead(200, {["Content-Type"] = "application/json"})
				res.send(json.encode{hash = hashPassword(password)})
			end, function(err)
				res.sendError(400, err)
			end)
		end
	}
})
