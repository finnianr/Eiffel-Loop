note
	description: "Shared access to routines of class ${EL_TUPLE_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-21 8:38:29 GMT (Wednesday 21st August 2024)"
	revision: "7"

deferred class
	EL_MODULE_TUPLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tuple: EL_TUPLE_ROUTINES
		once
			create Result.make
		end
end