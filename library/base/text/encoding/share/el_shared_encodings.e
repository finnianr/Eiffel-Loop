note
	description: "Shared instance of class ${EL_SYSTEM_ENCODINGS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_SHARED_ENCODINGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encodings: EL_SYSTEM_ENCODINGS
		once ("PROCESS")
			create Result
		end

end