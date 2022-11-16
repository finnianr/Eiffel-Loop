note
	description: "Principle or main application for installation"
	notes: "[
		This is the main or principle application in the set of sub-applications defined by the
		system root class implementing [$source EL_MULTI_APPLICATION_ROOT]. By default it is invoked by
		using the standard command-option:
		
			<application-command> -main
			
		In Windows this is the application that will be the app listed in the Control Panel/Programs List.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_MAIN_INSTALLABLE_APPLICATION

inherit
	EL_INSTALLABLE_APPLICATION

feature {NONE} -- Implementation

	option_name: READABLE_STRING_GENERAL
		do
			Result := Standard_option.main
		end

end