note
	description: "Module pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:18:59 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_MODULE_PYXIS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Pyxis: EL_PYXIS_XML_ROUTINES
		once
			create Result
		end

end
