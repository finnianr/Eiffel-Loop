note
	description: "Module system fonts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

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