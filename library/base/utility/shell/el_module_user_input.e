note
	description: "Module user input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

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
