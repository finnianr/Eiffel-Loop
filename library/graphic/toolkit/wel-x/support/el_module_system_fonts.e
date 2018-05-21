note
	description: "Module system fonts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_SYSTEM_FONTS

inherit
	EL_MODULE

feature -- Access

	System_fonts: EL_WEL_SYSTEM_FONTS
		once
			create Result
		end

end