note
	description: "Summary description for {EL_MODULE_USER_INPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
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
