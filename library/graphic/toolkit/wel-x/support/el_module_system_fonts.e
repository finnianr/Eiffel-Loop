note
	description: "Module system fonts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:18:42 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_MODULE_SYSTEM_FONTS

inherit
	EL_MODULE

feature {NONE} -- Constants

	System_fonts: EL_WEL_SYSTEM_FONTS
		once
			create Result
		end

end
