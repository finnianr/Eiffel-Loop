note
	description: "Module xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
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