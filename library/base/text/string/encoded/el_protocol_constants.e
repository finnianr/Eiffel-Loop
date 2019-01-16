note
	description: "Protocol constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-11 15:32:33 GMT (Friday 11th January 2019)"
	revision: "7"

class
	EL_PROTOCOL_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature -- Constants

	File_protocol_prefix: STRING = "file://"

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

	Protocol_sign: ZSTRING
		once
			Result := "://"
		end

	Secure_protocol: ZSTRING
		once
			Result := "https:"
		end

end
