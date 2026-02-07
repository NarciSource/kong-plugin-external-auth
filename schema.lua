local typedefs = require("kong.db.schema.typedefs")

return {
	name = "external-auth",
	fields = {
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
				},
			},
		},
	},
}
