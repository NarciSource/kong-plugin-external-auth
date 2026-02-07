package = "kong-plugin-external-auth"
version = "0.1.0-1"

local pluginName = "external-auth"

source = {
  url = "git://github.com/NarciSource/kong-plugin-external-auth"
}

description = {
  summary = "Kong plugin for external authentication via oauth2-proxy",
  homepage = "https://github.com/NarciSource/kong-plugin-external-auth",
  license = "Apache 2.0"
}

dependencies = {
  "lua >= 5.1",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.external-auth.handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins.external-auth.schema"] = "kong/plugins/"..pluginName.."/schema.lua"
  }
}
