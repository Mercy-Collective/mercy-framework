local mainResourceName = GetCurrentResourceName()

-- Default options for new HTTP handlers
local defaultOptions = {
	documentRoot = "http",
	directoryIndex = "index.html",
	templateExtension = "lsp",
	access = {},
	log = false,
	logFile = "log.json",
	errorPages = {},
	mimeTypes = {},
	routes = {}
}

-- The size of each block used when reading a file on disk
local blockSize = 131072

-- Maximum number of bytes to send in one ranged response
local maxContentLength = 5242880

local function createHttpHandler(options)
	local resourceName = GetInvokingResource() or GetCurrentResourceName()
	local resourcePath = GetResourcePath(resourceName)

	if type(options) ~= "table" then
		options = {}
	end

	for key, defaultValue in pairs(defaultOptions) do
		if options[key] == nil then
			options[key] = defaultValue
		end
	end

	local handlerLog

	if options.log then
		handlerLog = json.decode(LoadResourceFile(resourceName, options.logFile)) or {}
	end

	local authorizations = {}

	local realm

	if type(options.authorization) == "string" then
		realm = options.authorization
		options.authorization = Realms[realm] or {}
	else
		realm = resourceName
	end

	local function getExtension(path)
		return path:match("^.+%.(.+)$")
	end

	local function getMimeType(path)
		local extension = getExtension(path)

		if options.mimeTypes[extension] then
			return options.mimeTypes[extension]
		elseif MimeTypes[extension] then
			return MimeTypes[extension]
		else
			return "application/octet-stream"
		end
	end

	local function parseTemplate(content, name, env)
		if type(env) ~= "table" then
			env = {}
		end

		for k, v in pairs(_G) do
			if env[k] == nil then
				env[k] = v
			end
		end

		local parsed = content

		parsed = parsed:gsub("(%%%b{})", function(w)
			local fn, err = load(w:sub(3, -2), name, "t", env)

			if fn then
				local status, res = pcall(fn)
				return res or ""
			else
				return err
			end
		end)

		parsed = parsed:gsub("($%b{})", function(w)
			local fn, err = load("return (" .. w:sub(3, -2) .. ")", nil, "t", env)

			if fn then
				local status, res = pcall(fn)
				return res or ""
			else
				return err
			end
		end)

		return parsed
	end

	local function sendError(req, res, code, details, headers)
		if not code then
			code = 500
		end

		if details == nil then
			details = false
		end

		if type(headers) ~= "table" then
			headers = {}
		end

		if not headers["Content-Type"] then
			headers["Content-Type"] = "text/html"
		end

		res.writeHead(code, headers)

		if req.method == "HEAD" then
			res.send()
		else
			local resource, path

			if options.errorPages[code] then
				resource = resourceName
				path = options.documentRoot .. "/" .. options.errorPages[code]
			else
				resource = mainResourceName
				path = defaultOptions.documentRoot .. "/" .. code .. ".html"
			end

			local data = LoadResourceFile(resource, path)

			if data then
				res.send(parseTemplate(data, path, {details = details}))
			else
				if details then
					res.send("Error: " .. code .. ": " .. details)
				else
					res.send("Error: " .. code)
				end
			end
		end
	end

	local function log(entry)
		if not handlerLog then
			return
		end

		entry.time = os.time()

		table.insert(handlerLog, entry)

		table.sort(handlerLog, function(a, b)
			return a.time < b.time
		end)

		SaveResourceFile(resourceName, options.logFile, json.encode(handlerLog), -1)
	end

	local function sendTemplate(req, res, content, name, env, code, headers)
		if type(env) ~= "table" then
			env = {}
		end

		env.request = req

		if not code then
			code = 200
		end

		if type(headers) ~= "table" then
			headers = {}
		end

		if not headers["Content-Type"] then
			headers["Content-Type"] = "text/html"
		end

		local parsed = parseTemplate(content, name, env)

		res.writeHead(code, headers)
		res.send(parsed)
	end

	local function getAbsolutePath(path)
		if path:sub(1, 1) ~= "/" then
			path = "/" .. path
		end

		return resourcePath .. "/" .. options.documentRoot .. path
	end

	local function sendTemplateFile(req, res, path, env, code, headers)
		local absolutePath = getAbsolutePath(path)

		local f = io.open(absolutePath, "rb")

		if f then
			local content = f:read("*all")
			f:close()

			sendTemplate(req, res, content, path, env, code, headers)
		else
			sendError(req, res, 404)
		end
	end

	local function sendFile(req, res, path)
		local absolutePath = getAbsolutePath(path)

		local mimeType = getMimeType(absolutePath)

		local f = io.open(absolutePath, "rb")

		local statusCode

		if f then
			local startBytes, endBytes

			if req.headers.Range then
				startBytes = tonumber(req.headers.Range:match("^bytes=(%d+)-.*$"))
				endBytes = tonumber(req.headers.Range:match("^bytes=%d+-(%d+)$"))
			end

			if not startBytes or startBytes < 0 then
				startBytes = 0
			end

			local fileSize = f:seek("end")
			f:seek("set", startBytes)

			if not endBytes then
				if req.headers.Range then
					endBytes = math.min(startBytes + maxContentLength, fileSize) - 1
				else
					endBytes = fileSize - 1
				end
			end

			local headers = {
				["Content-Type"] = mimeType,
				["Transfer-Encoding"] = "identity",
				["Accept-Ranges"] = "bytes"
			}

			if startBytes > 0 or endBytes < fileSize - 1 then
				statusCode = 206

				headers["Content-Range"] = ("bytes %d-%d/%d"):format(startBytes, endBytes, fileSize)
				headers["Content-Length"] = tostring(endBytes - startBytes + 1)
			else
				statusCode = 200

				headers["Content-Length"] = tostring(fileSize)
			end

			res.writeHead(statusCode, headers)

			Citizen.CreateThread(function()
				if req.method ~= "HEAD" then
					local cancelled = false

					req.setCancelHandler(function()
						cancelled = true
					end)

					while not cancelled do
						if startBytes > endBytes then
							break
						end

						local block = f:read(blockSize)

						if not block then
							break
						end

						res.write(block)

						startBytes = startBytes + blockSize

						Citizen.Wait(0)
					end
				end

				res.send()

				f:close()
			end)
		else
			statusCode = 404

			sendError(req, res, statusCode)
		end

		log {
			type = "file",
			path = req.path,
			address = req.address,
			method = req.method,
			headers = req.headers,
			status = statusCode,
			file = absolutePath
		}

		return statusCode
	end

	local function readJson(req)
		local p = promise.new()

		req.setDataHandler(function(body)
			local data = json.decode(body)

			if data == nil then
				p:reject("Request body contains invalid JSON")
			else
				p:resolve(data)
			end
		end)

		return p
	end

	local function sendJson(req, res, data, code, headers)
		if not code then
			code = 200
		end

		if type(headers) ~= "table" then
			headers = {}
		end

		if not headers["Content-Type"] then
			headers["Content-Type"] = "application/json"
		end

		res.writeHead(code, headers)

		if req.method == "HEAD" then
			res.send()
		else
			if type(data) == "string" then
				res.send(data)
			else
				res.send(json.encode(data))
			end
		end
	end

	local function isAuthorized(req, path)
		local login

		for i = #options.access, 1, -1 do
			if path:match(options.access[i].path) then
				login = options.access[i].login
				break
			end
		end

		if login == false then
			return true
		end

		local auth = req.headers.Authorization

		if not auth then
			return false
		end

		local encoded = auth:match("^Basic (.+)$")

		if not encoded then
			return false
		end

		local decoded = base64.decode(encoded)

		local username, password = decoded:match("^([^:]+):(.+)$")

		if not (username and password) then
			return false
		end

		if login and not login[username] then
			return false
		end

		req.user = username

		if authorizations[auth] then
			return true
		end

		if not options.authorization[username] then
			return false
		end

		if not verifyPassword(password, options.authorization[username]) then
			return false
		end

		authorizations[auth] = true

		return true
	end

	return function(req, res)
		local url = Url.normalize(req.path)

		req.url = url

		if options.authorization and not isAuthorized(req, url.path) then
			sendError(req, res, 401, "Invalid login for realm: " .. realm, {
				["WWW-Authenticate"] = ("Basic realm=\"%s\""):format(realm)
			})
			return
		end

		for pattern, callback in pairs(options.routes) do
			local matches = {url.path:match(pattern)}

			if #matches > 0 then
				req.readJson = function()
					return readJson(req)
				end

				res.sendError = function(code, details, headers)
					sendError(req, res, code, details, headers)
				end

				res.sendFile = function(path)
					sendFile(req, res, path)
				end

				res.sendJson = function(data, code, headers)
					sendJson(req, res, data, code, headers)
				end

				res.sendTemplate = function(content, env, code, headers)
					sendTemplate(req, res, content, url.path, env, code, headers)
				end

				res.sendTemplateFile = function(path, env, code, headers)
					sendTemplateFile(req, res, path, env, code, headers)
				end

				local helpers = {
					log = function(entry)
						entry.type = "message"
						entry.route = pattern
						log(entry)
					end
				}

				callback(req, res, helpers, table.unpack(matches))

				log {
					type = "route",
					route = pattern,
					path = req.path,
					address = req.address,
					method = req.method,
					headers = req.headers,
				}

				return
			end
		end

		if options.documentRoot then
			if url.path:sub(-1) == "/" then
				url.path = url.path .. options.directoryIndex
			end

			local extension = getExtension(url.path)

			if extension == options.templateExtension then
				sendTemplateFile(req, res, url.path)
			else
				sendFile(req, res, url.path)
			end
		else
			sendError(req, res, 404, "No route matches " .. url)
		end
	end
end

exports("createHttpHandler", createHttpHandler)

exports("getUrl", function(resourceName)
	local baseUrl = GetConvar("web_baseUrl", "")

	local protocol, endpoint

	if baseUrl == "" then
		protocol = "http"
		endpoint = "[server IP]:[server port]"
	else
		protocol = "https"
		endpoint = baseUrl
	end

	if not resourceName then
		resourceName = GetInvokingResource() or mainResourceName
	end

	return ("%s://%s/%s/"):format(protocol, endpoint, resourceName)
end)

-- Apply inheritance for realms
for realm, users in pairs(Realms) do
	if users.inherit and Realms[users.inherit] then
		local inheritedRealms

		if type(users.inherit) == "table" then
			inheritedRealms = users.inherit
		else
			inheritedRealms = {users.inherit}
		end

		for _, inheritedRealm in ipairs(inheritedRealms) do
			for username, password in pairs(Realms[inheritedRealm]) do
				users[username] = password
			end
		end

		users.inherit = nil
	end
end
