note
	description: "Shared access to routines of class [$source EL_XML_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-03 8:30:40 GMT (Sunday 3rd May 2020)"
	revision: "9"

deferred class
	EL_MODULE_XML

inherit
	EL_MODULE

feature {NONE} -- Constants

	XML: EL_XML_ROUTINES
			--
		once
			create Result
		end

end
