note
	description: "Shared instance of [$source PP_L_VARIABLE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 18:25:16 GMT (Saturday 28th April 2018)"
	revision: "6"

class
	PP_SHARED_L_VARIABLE_ENUM

feature {NONE} -- Constants

	L_variable: PP_L_VARIABLE_ENUM
		once
			create Result.make
		end

end
