note
	description: "Shared instance of class ${EL_SYSTEM_ENCODINGS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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