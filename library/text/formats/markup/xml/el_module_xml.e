note
	description: "Shared access to routines of class [$source XML_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:25:13 GMT (Sunday 1st January 2023)"
	revision: "12"

deferred class
	EL_MODULE_XML

inherit
	EL_MODULE

feature {NONE} -- Constants

	XML: XML_ROUTINES_IMP
			--
		once
			create Result
		end

end