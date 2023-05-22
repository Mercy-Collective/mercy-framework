# httpmanager

HTTP handler utility for FiveM and RedM. It can be used as a simple file server, or to provide easy HTTP functionality to any resource.

# Installation

1. Place in your resources directory.

2. Add `start httpmanager` to server.cfg.

# Usage

## As a standalone file server

After installing, you can place files in the `http` folder inside the `httpmanager` resource folder, and those files will be accessible at:

```
http://[server IP]:[server port]/httpmanager/...
```
or
```
https://[owner]-[server ID].users.cfx.re/httpmanager/...
```

For example, if you place a file named `test.html` in the `http` folder, it would be accessible at `http://[server IP]:[server port]/httpmanager/test.html`.

## In other resources

You can quickly add HTTP functionality to any resource using the `createHttpHandler` export:

```lua
handler = exports.httpmanager:createHttpHandler(options)
```

This creates a new HTTP handler that can be used with `SetHttpHandler` in a server script in the resource:

```lua
SetHttpHandler(exports.httpmanager:createHttpHandler())
```

`options` is a table containing configuration options for the new handler. Any unspecified options will be given their default value.

| Option              | Description                                                                                  | Default        |
|---------------------|----------------------------------------------------------------------------------------------|----------------|
| `documentRoot`      | The directory in the resource folder where files are served from.                            | `"http"`       |
| `directoryIndex`    | If the path points to a directory, a file with this name inside that directory will be sent. | `"index.html"` |
| `templateExtension` | File extension for files that will be automatically preprocessed as templates.               | `"lsp"`        |
| `authorization`     | A table of usernames and passwords required to access any files or routes.                   | `nil`          |
| `access`            | A table of paths with which users can access them.                                           | `{}`           |
| `log`               | Whether to log requests to a file in the resource directory.                                 | `false`        |
| `logFile`           | If `log` is `true`, store the log in this file in the resource directory.                    | `"log.json"`   |
| `errorPages`        | A table of custom pages for different error codes (e.g., 404).                               | `{}`           |
| `mimeTypes`         | A table of MIME type associations for extensions, which will override any detected type.     | `{}`           |
| `routes`            | A table of route patterns and callbacks.                                                     | `{}`           |

```lua
SetHttpHandler(exports.httpmanager:createHttpHandler {
	documentRoot = "root",
	directoryIndex = "index.html",
	templateExtension = "html",
	authorization = {
		["admin"] = "$2a$11$HoxJPx5sTe4RX5qPw1OkSO.ukDdwAvGJwXtmyOE5i.1gz7EvN71.q",
		["user"] = "$2a$11$ILOCJlRiUPhRpmqYiZDDM.EdI16yOtMBTLJKTBLSUHTFzyXjXHJYa"
	},
	access = {
		{path = "/admin/.*", login = {["admin"] = true}},
		{path = "/public/.*", login = false},
		{path = "/public/secret/.*"}
	},
	log = true,
	logFile = "log.json",
	errorPages = {
		[404] = "custom404.html"
	},
	mimeTypes = {
		["ogg"] = "audio/ogg"
	},
	routes = {
		["/players/(%d+)"] = function(req, res, helpers, player)
			if GetPlayerEndpoint(player) then
				res.send(GetPlayerName(player))
			else
				res.sendError(404)
			end
		end
	}
})
```

## Authorization

Access to a handler can be controlled by the `authorization` option. If `authorization` is unset, then no restrictions are applied. If `authorization` is a table of usernames and passwords, then access will only be granted once a client has been authenticated using one of these username/password combinations.

Passwords in the `authorization` table must be hashed. httpmanager includes a built-in utility for generating password hashes, which can be accessed at `http://[server IP]:[server port]/httpmanager/password/`.

```lua
authorization = {
	["admin"] = "$2a$11$HoxJPx5sTe4RX5qPw1OkSO.ukDdwAvGJwXtmyOE5i.1gz7EvN71.q"
}
```

Rather than defining users separately for every resource, you can define central groups of users using realms. Realms are configured in [realms.lua](realms.lua):

```lua
Realms = {
	["default"] = {
		["admin"] = "$2a$11$HoxJPx5sTe4RX5qPw1OkSO.ukDdwAvGJwXtmyOE5i.1gz7EvN71.q"
	},
	["realm1"] = {
		inherit = "default",
		["user1"] = "$2a$11$4RIDavyfsCw/vhImQdDYcOKgCnnJ0ZcJQCFeM8wfF1jkEGN/YnOOG",
		["user2"] = "$2a$11$dMe9J7jkhg8N5E/VArrEn.1UKhB9QocNqDopPJkcRNXQ1p4KQDdQG"
	},
	["realm2"] = {
		...
	}
}
```

To use a realm, specify its name as a string for `authorization`:

```lua
SetHttpHandler(exports.httpmanager:createHttpHandler{
	authorization = "realm1"
})
```

Resources which use the same realm will share the same logins, allowing users to go between them without re-entering their password.

Access can be further refined using the `access` option. `access` is a table of rules that each specify a path pattern and which users (as defined in the `authorization` table) can access it.

```lua
access = {
	{path = "/admin/.*", login = {["admin"] = true}},
	{path = "/public/.*", login = false},
	{path = "/public/secret/.*"}
}
```

In this example, anything under `/admin/` can only be accessed by the user `admin`, and no other users in the `authorization` table. Things under `/public/` require no login, and can be accessed by anyone. However, the last rule adds an exception, where anything under `/public/secret/` goes back to the default of allowing only authorized users access.

The `path` in an access rule is a [Lua pattern](https://www.lua.org/pil/20.2.html). Access rules are tested in reverse order, so later rules will override earlier rules.

## Routes

Routes are handlers for specific URL patterns. When a URL matching one of these patterns is requested, the request is directed to a callback function to determine the response. URLs that match no routes are handled as simple file requests.

Routes use [Lua patterns](https://www.lua.org/pil/20.2.html), and any [captures](https://www.lua.org/pil/20.3.html) are passed as parameters to the route handler function.

An example route is `/players/(%d+)`. This would match a URL like `/players/3`. If you wanted the name of the player on the server with the specified ID number to be the response, you could use a handler like this:

```lua
routes = {
	["/players/(%d+)"] = function(request, response, helpers, player)
		if GetPlayerEndpoint(player) then
			response.send(GetPlayerName(player))
		else
			response.sendError(404)
		end
	end
}
```

The `request`, `response`, and `helpers` arguments provide the interface for getting data from clients and sending data back to clients.

### `request`

The incoming request from the client.

#### `request.path`

The raw path of the request.

#### `request.url`

The parsed URL, containing the normalized path (`url.path`) and query parameters (`url.query`).

#### `request.method`

The HTTP method of the request.

#### `request.headers`

The HTTP headers of the request.

#### `request.user`

If authentication is required, this will contain the authenticated name of the user.

#### `request.readJson()`

Reads the body of the request as JSON, deserializes it, and returns a promise which is resolved with the result (or rejected with any errors encountered):

```lua
-- POST request: /multiply-by-two
-- POST body: {"input": 3}
request.readJson():next(function(data)
	response.sendJson{output = data.input * 2}
end)
```

### `response`

The response that will be sent back to the client.

#### `response.writeHead(code, [headers])`

Sets the HTTP status code and other headers of the response.

#### `response.write(data)`

Writes data to the body of the response without closing it.

#### `response.send(data)`

Writes data to the body of the response and closes it. No arguments will close the response without sending any additional data.

#### `response.sendError(code, [details, [headers]])`

Sends an error page as the response.

#### `response.sendFile(path)`

Sends a file as the response.

#### `response.sendJson(data, [code, [headers]])`

Sends JSON data as the response. If `data` is a string, it is sent as-is. If `data` is not a string, it is encoded to a string with `json.encode`.

#### `response.sendTemplate(content, [env, [code, [headers]]])`

Processes and sends a template string as the response.

#### `response.sendTemplateFile(path, [env, [code, [headers]]])`

Processes and sends a template file as the response.

### `helpers`

Other helper functions.

#### `helpers.log(entry)`

Add an entry to the log. `entry` is a table that can contain any fields.

## Templates

Templates are strings or files which may contain variables or pieces of Lua code, which are preprocessed server-side before being sent in a response.

There are two kinds of directives that can be used in a template:

- `${...}` is replaced by the value of the expression inside.
- `%{...}` is replaced by the return value of the block inside.

### Expression directive

```html
<p>Hello, ${name}!</p>
```

```lua
response.sendTemplateFile("test.html", {name = "Alice"})
```

### Block directive

```html
<p><strong>%{
local lang = request.url.query["lang"]

if lang == "es" then
	return "Numero de jugadores"
elseif lang == "fr" then
	return "Nombre de joueurs"
else
	return "Number of players"
end
}:</strong> ${#GetPlayers()}</p>
```

Variables can be defined in the `env` parameter to the template helper functions. A `request` variable always exists and contains the request information, just like a route callback.

The `templateExtension` option to `createHttpHandler` allows specifying an extension for HTML files which are automatically processed as templates. The default extension is `.lsp`, so a file named `mypage.lsp` will be automatically processed as a template when it is requested.
