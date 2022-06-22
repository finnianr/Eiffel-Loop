note
	description: "Shared access to routines of class [$source XML_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 10:01:04 GMT (Wednesday 22nd June 2022)"
	revision: "10"

deferred class
	EL_MODULE_XML

inherit
	EL_MODULE

feature {NONE} -- Constants

	XML: XML_ROUTINES
			--
		once
			create Result
		end

end
