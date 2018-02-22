local resty_md5 = require "resty.md5"
local str = require "resty.string"

local md5 = resty_md5:new()
md5:update("987654321")
md5:update("abcdef")

local digest = md5:final()

ngx.say("md5.digest: ", str.to_hex(digest))
