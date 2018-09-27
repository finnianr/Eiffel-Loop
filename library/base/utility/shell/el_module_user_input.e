note
	description: "Module user input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

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
