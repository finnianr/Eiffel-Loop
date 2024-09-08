note
	description: "Principle or main application for installation"
	notes: "[
		This is the main or principle application in the set of sub-applications defined by the
		system root class implementing ${EL_MULTI_APPLICATION_ROOT}. By default it is invoked by
		using the standard command-option:
		
			<application-command> -main
			
		In Windows this is the application that will be the app listed in the Control Panel/Programs List.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 8:23:35 GMT (Sunday 8th September 2024)"
	revision: "6"

deferred class
	EL_MAIN_INSTALLABLE_APPLICATION

inherit
	EL_INSTALLABLE_APPLICATION

feature -- Access

	compatibility_mode: STRING
		-- compatibility mode for Windows for registry entry. Eg. WIN7
		deferred
		end

feature -- Status query

	is_main: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	option_name: READABLE_STRING_GENERAL
		do
			Result := Standard_option.main
		end

end