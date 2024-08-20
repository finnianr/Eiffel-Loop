note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-20 8:28:50 GMT (Saturday 20th July 2024)"
	revision: "16"

deferred class
	EL_PROTOCOL_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Implementation

	url_stem (a_protocol: STRING): STRING
		do
			Result := a_protocol + Colon_slash_x2
		end

feature {NONE} -- Constants

	Colon_slash_x2: STRING = "://"

	Localhost: STRING = "localhost"

	Protocol: TUPLE [file, ftp, http, https, ssh: STRING]
		-- common protocols
		-- (Tried using IMMUTABLE_STRING_8 but too many ramifications)
		once
			create Result
			Tuple.fill (Result, "file, ftp, http, https, ssh")
		end

	Secure_protocol: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make (Protocol.http, Protocol.https)
		end

end