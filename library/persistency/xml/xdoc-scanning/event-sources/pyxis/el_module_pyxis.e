note
	description: "Summary description for {EL_MODULE_PYXIS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MODULE_PYXIS

inherit
	EL_MODULE

feature -- Access

	Pyxis: EL_PYXIS_XML_ROUTINES
		once
			create Result
		end

end
