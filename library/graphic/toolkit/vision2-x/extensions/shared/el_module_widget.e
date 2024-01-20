note
	description: "Shared instance of class ${EL_WIDGET_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_MODULE_WIDGET

inherit
	EL_MODULE

feature {NONE} -- Constants

	Widget: EL_WIDGET_ROUTINES
			--
		once ("PROCESS")
			create Result
		end
end