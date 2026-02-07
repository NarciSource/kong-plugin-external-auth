local typedefs = require("kong.db.schema.typedefs")

return {
	name = "external-auth",
	fields = {
		{ consumer = typedefs.no_consumer },
		{ protocols = typedefs.protocols_http },

		{
			config = {
				type = "record",
				fields = {

					{
						-- 인증 요청을 보낼 외부 서비스 URL --
						url = typedefs.url({
							required = true,
						}),
					},

					{
						connect_timeout = {
							type = "number",
							default = 2000,
						},
					},

					{
						send_timeout = {
							type = "number",
							default = 2000,
						},
					},

					{
						read_timeout = {
							type = "number",
							default = 5000,
						},
					},
				},
			},
		},
	},
}
