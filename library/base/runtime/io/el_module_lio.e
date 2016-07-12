note
	description: "[
		Access to instance of `EL_CONSOLE_ONLY_LOG' which serves as an extension of the standard `io'
		object. As the name implies, output is sent only to the terminal console.
		
		**Features**
		
		* Output through `lio' object is color highlighted for the gnome-terminal.
		
		* Output filtering is available via `Console.show' and `Console.show_all'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-09 8:17:09 GMT (Saturday 9th July 2016)"
	revision: "5"

class
	EL_MODULE_LIO

inherit
	EL_MODULE

	EL_MODULE_CONSOLE

feature -- Access

	Lio: EL_LOGGABLE
		once
			Result := new_lio
		end

feature -- Status query

	is_lio_enabled: BOOLEAN
		-- True if the `Current' type has been registered in console manger with call to
		-- `Console.show ({MY_TYPE})'
		do
			Result := Console.is_type_visible ({like Current})
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			create {EL_CONSOLE_ONLY_LOG} Result.make
		end
end
