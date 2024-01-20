note
	description: "Shared instance of ${PP_L_VARIABLE_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

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