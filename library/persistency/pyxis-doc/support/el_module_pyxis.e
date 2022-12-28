note
	description: "Module pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 18:48:17 GMT (Wednesday 28th December 2022)"
	revision: "9"

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