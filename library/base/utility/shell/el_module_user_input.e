note
	description: "Summary description for {EL_MODULE_USER_INPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 10:49:32 GMT (Thursday 28th December 2017)"
	revision: "3"

class
	EL_MODULE_USER_INPUT

inherit
	EL_MODULE

feature -- Access

	User_input: EL_USER_INPUT
			--
		once
			create Result
		end

end
