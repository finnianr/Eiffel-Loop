note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "13"

deferred class
	EL_PROTOCOL_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Http_protocols: ARRAY [STRING]
		once
			Result := << Protocol.http, Protocol.https >>
			Result.compare_objects
		end

	Protocol: TUPLE [file, ftp, http, https, ssh: STRING]
			-- common protocols
		once
			create Result
			Tuple.fill (Result, "file, ftp, http, https, ssh")
		end

	Colon_slash_x2: STRING = "://"

end