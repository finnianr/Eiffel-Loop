note
	description: "[
		Performs a http download using the connection `connection' and stores
		the data in the string `string'. Windows style newlines ("%R%N") are converted to Unix style.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 12:11:56 GMT (Saturday 15th November 2025)"
	revision: "6"

class
	EL_GET_HTTP_COMMAND

inherit
	EL_STRING_DOWNLOAD_HTTP_COMMAND
		redefine
			prepare
		end

create
	make

feature {NONE} -- Implementation

	prepare
		do
			curl.enable_get_method
			Precursor
		end

end