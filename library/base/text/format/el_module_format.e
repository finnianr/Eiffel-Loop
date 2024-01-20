note
	description: "Shared access to routines of class ${EL_FORMAT_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_MODULE_FORMAT

inherit
	EL_MODULE

feature {NONE} -- Constants

	Format: EL_FORMAT_ROUTINES
		once
			create Result.make
		end
end