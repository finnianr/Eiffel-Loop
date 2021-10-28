note
	description: "Shared instance of class [$source EL_SYSTEM_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 9:23:10 GMT (Tuesday 26th October 2021)"
	revision: "2"

deferred class
	EL_MODULE_ENCODINGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encodings: EL_SYSTEM_ENCODINGS
		once ("PROCESS")
			create Result
		end

end