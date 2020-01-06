note
	description: "Shared instance of [$source PP_L_VARIABLE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:58:33 GMT (Monday 1st July 2019)"
	revision: "8"

deferred class
	PP_SHARED_L_VARIABLE_ENUM

inherit
	EL_ANY_SHARED
	
feature {NONE} -- Constants

	L_variable: PP_L_VARIABLE_ENUM
		once
			create Result.make
		end

end
