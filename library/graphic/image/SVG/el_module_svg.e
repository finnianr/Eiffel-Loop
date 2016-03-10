note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-11 16:23:05 GMT (Monday 11th February 2013)"
	revision: "2"

class
	EL_MODULE_SVG

inherit
	EL_MODULE

feature -- Access

	SVG: EL_MODULE_SVG_ROUTINES
		once
			create Result.make
		end

end
