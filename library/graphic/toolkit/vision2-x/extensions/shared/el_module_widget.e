note
	description: "Shared instance of class [$source EL_WIDGET_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 13:54:28 GMT (Monday 31st August 2020)"
	revision: "1"

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
