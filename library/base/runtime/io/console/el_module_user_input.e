note
	description: "Module user input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 10:51:10 GMT (Sunday 23rd December 2018)"
	revision: "8"

class
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
