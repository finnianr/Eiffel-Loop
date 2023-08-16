note
	description: "Shared access to routines of class [$source XML_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 15:16:06 GMT (Wednesday 2nd August 2023)"
	revision: "13"

deferred class
	EL_MODULE_XML

inherit
	EL_MODULE

feature {NONE} -- Constants

	XML: XML_ROUTINES_IMP
		once
			create Result
		end

end