note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 12:42:25 GMT (Sunday 24th May 2020)"
	revision: "9"

deferred class
	EL_PROTOCOL_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature -- Constants

	Http_protocols: ARRAY [ZSTRING]
		once
			Result := << Protocol.http, Protocol.https >>
			Result.compare_objects
		end

	Protocol: TUPLE [file, ftp, http, https: ZSTRING]
			-- common protocols
		once
			create Result
			Tuple.fill (Result, "file, ftp, http, https")
		end

	Colon_slash_x2: ZSTRING
		once
			Result := "://"
		end

end
