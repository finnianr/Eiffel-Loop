note
	description: "Summary description for {EL_MODULE_USER_INPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:45:53 GMT (Friday 14th June 2013)"
	revision: "2"

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
