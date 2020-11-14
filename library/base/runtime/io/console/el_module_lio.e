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
	date: "2020-11-14 9:45:41 GMT (Saturday 14th November 2020)"
	revision: "13"

deferred class
	EL_MODULE_LIO

inherit
	EL_MODULE

	EL_MODULE_CONSOLE

	EL_SHARED_BASE_OPTION

feature {NONE} -- Access

	lio: EL_LOGGABLE
		do
			Result := Once_lio
			Result.set_logged_object (Current)
		end

	Sio, Silent_io: EL_SILENT_LOG
		-- do nothing log
		once
			create Result.make
		end

feature {NONE} -- Status query

	is_lio_enabled: BOOLEAN
		-- True if the `Current' type has been registered in console manger with call to
		-- `Console.show ({MY_TYPE})'
		do
			Result := Console.is_type_visible ({ISE_RUNTIME}.dynamic_type (Current))
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			if Base_option.silent then
				create {EL_SILENT_LOG} Result.make
			else
				create {EL_CONSOLE_ONLY_LOG} Result.make
			end
		end

	Once_lio: EL_LOGGABLE
		once
			Result := new_lio
		end

end