note
	description: "Module pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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