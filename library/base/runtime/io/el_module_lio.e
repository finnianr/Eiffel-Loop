note
	description: "[
		Access to instance of [$source EL_CONSOLE_ONLY_LOG] which serves as an extension of the standard `io'
		object. As the name implies, output is sent only to the terminal console.
		
		**Features**
		
		* Output through `lio' object is color highlighted for the gnome-terminal.
		
		* Output filtering is available via `Console.show' and `Console.show_all'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:19:30 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_LIO

inherit
	EL_MODULE

	EL_MODULE_CONSOLE

	EL_MODULE_ARGS

feature {NONE} -- Access

	Lio: EL_LOGGABLE
		once
			Result := new_lio
		end

feature {NONE} -- Status query

	is_lio_enabled: BOOLEAN
		-- True if the `Current' type has been registered in console manger with call to
		-- `Console.show ({MY_TYPE})'
		do
			Result := Console.is_type_visible ({like Current})
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			if Args.has_silent then
				create {EL_SILENT_LOG} Result
			else
				create {EL_CONSOLE_ONLY_LOG} Result.make
			end
		end
end
