note
	description: "Module pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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