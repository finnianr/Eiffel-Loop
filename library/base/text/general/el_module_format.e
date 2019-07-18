note
	description: "Module format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:55:19 GMT (Monday 1st July 2019)"
	revision: "2"

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
