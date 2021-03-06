note
	description: "Shared access to routines of class [$source EL_USER_INPUT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:26:32 GMT (Thursday 6th February 2020)"
	revision: "10"

deferred class
	EL_MODULE_USER_INPUT

inherit
	EL_MODULE

feature {NONE} -- Constants

	User_input: EL_USER_INPUT
			--
		once
			create Result
		end

end
