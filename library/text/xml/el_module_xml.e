note
	description: "Summary description for {EL_MODULE_XML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:48:19 GMT (Friday 14th June 2013)"
	revision: "3"

class
	EL_MODULE_XML

inherit
	EL_MODULE

feature -- Access

	Xml: EL_XML_ROUTINES
			--
		once
			create Result
		end

end
