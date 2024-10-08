note
	description: "Access to routines of ${EL_UTF_CONVERTER_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 18:07:47 GMT (Sunday 25th August 2024)"
	revision: "6"

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