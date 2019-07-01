note
	description: "Module format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-13 10:26:42 GMT (Wednesday 13th March 2019)"
	revision: "1"

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
