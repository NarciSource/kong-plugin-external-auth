local http = require("resty.http")

local ExternalAuthHandler = {
	PRIORITY = 1000,
	VERSION = "1.0.0",
}

function ExternalAuthHandler:access(conf)
	local client = http.new()

	client:set_timeouts(conf.connect_timeout, conf.send_timeout, conf.read_timeout)

	local res, err = client:request_uri(conf.url, {
		method = kong.request.get_method(),
		headers = kong.request.get_headers(),
	})

	if not res then
		return kong.response.exit(500, { message = err })
	end

	if res.status ~= 200 then
		return kong.response.exit(401)
	end

	local accessToken = res.headers["X-Auth-Request-Access-Token"]

	if accessToken then
		kong.service.request.clear_header("Authorization")

		kong.service.request.set_header("Authorization", "Bearer " .. accessToken)
	else
		kong.log.err("No X-Auth-Request-Access-Token header received")
	end
end

return ExternalAuthHandler
