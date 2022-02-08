note
	description: "Principle or main application for installation"
	notes: "[
		This is the principle application from the whole set of sub-applications.
		In Windows this will be the app listed in the Control Panel/Programs List
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 10:10:39 GMT (Tuesday 8th February 2022)"
	revision: "2"

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