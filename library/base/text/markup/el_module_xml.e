note
	description: "Summary description for {EL_MODULE_XML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-24 12:00:38 GMT (Sunday 24th May 2015)"
	revision: "4"

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
