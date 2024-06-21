note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-18 10:33:03 GMT (Tuesday 18th June 2024)"
	revision: "15"

deferred class
	EL_PROTOCOL_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Secure_protocol: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make (Protocol.http, Protocol.https)
		end

	Protocol: TUPLE [file, ftp, http, https, ssh: STRING]
		-- common protocols
		-- (Tried using IMMUTABLE_STRING_8 but too many ramifications)
		once
			create Result
			Tuple.fill (Result, "file, ftp, http, https, ssh")
		end

	Colon_slash_x2: STRING = "://"

	Localhost: STRING = "localhost"

end