note
	description: "Shared instance of class [$source EL_SYSTEM_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 11:08:25 GMT (Wednesday 9th February 2022)"
	revision: "3"

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