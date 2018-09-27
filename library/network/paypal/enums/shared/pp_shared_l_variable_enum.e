note
	description: "Shared instance of [$source PP_L_VARIABLE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "7"

class
	PP_SHARED_L_VARIABLE_ENUM

feature {NONE} -- Constants

	L_variable: PP_L_VARIABLE_ENUM
		once
			create Result.make
		end

end
