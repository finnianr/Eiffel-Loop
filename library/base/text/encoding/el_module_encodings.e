note
	description: "Shared instance of class SYSTEM_ENCODINGS"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 10:13:10 GMT (Sunday 5th April 2020)"
	revision: "1"

deferred class
	EL_MODULE_ENCODINGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encodings: SYSTEM_ENCODINGS
		once ("PROCESS")
			create Result
		end

end
