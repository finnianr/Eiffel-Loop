note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-02 12:16:58 GMT (Tuesday 2nd June 2020)"
	revision: "11"

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

	Protocol: TUPLE [file, ftp, http, https: STRING]
			-- common protocols
		once
			create Result
			Tuple.fill (Result, "file, ftp, http, https")
		end

	Colon_slash_x2: STRING = "://"

end
