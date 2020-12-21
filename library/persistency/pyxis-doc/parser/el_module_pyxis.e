note
	description: "Module pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:54:09 GMT (Monday 1st July 2019)"
	revision: "7"

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
