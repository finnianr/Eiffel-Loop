note
	description: "Shared instance of class ${EL_SYSTEM_ERROR_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 13:24:36 GMT (Thursday 22nd August 2024)"
	revision: "1"

deferred class
	EL_SHARED_SYSTEM_ERROR_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	System_error_table: EL_SYSTEM_ERROR_TABLE
		once
			create Result
		end
end