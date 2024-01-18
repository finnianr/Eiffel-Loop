note
	description: "Shared instance of ${PP_L_VARIABLE_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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