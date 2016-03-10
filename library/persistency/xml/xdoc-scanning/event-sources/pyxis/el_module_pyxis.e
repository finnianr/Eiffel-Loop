note
	description: "Summary description for {EL_MODULE_PYXIS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-31 14:24:36 GMT (Monday 31st December 2012)"
	revision: "2"

class
	EL_MODULE_PYXIS

inherit
	EL_MODULE

feature -- ac

	Pyxis: EL_PYXIS_XML_ROUTINES
		once
			create Result
		end

end
