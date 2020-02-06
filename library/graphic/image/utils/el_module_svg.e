note
	description: "Shared access to routines of class [$source EL_SVG_IMAGE_UTILS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:23:37 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_SVG

inherit
	EL_MODULE

feature {NONE} -- Constants

	SVG: EL_SVG_IMAGE_UTILS
		once
			create Result
		end

end
