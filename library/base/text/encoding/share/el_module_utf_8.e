note
	description: "Access to routines of ${EL_UTF_CONVERTER_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 17:51:22 GMT (Tuesday 15th April 2025)"
	revision: "7"

deferred class
	EL_MODULE_UTF_8

inherit
	EL_MODULE

feature {NONE} -- Constants

	Utf_8: EL_UTF_8_CONVERTER_IMP
		once
			create Result
		end
end