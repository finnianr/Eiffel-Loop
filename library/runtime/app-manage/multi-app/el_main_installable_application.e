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
	date: "2022-02-07 11:44:09 GMT (Monday 7th February 2022)"
	revision: "1"

deferred class
	EL_MAIN_INSTALLABLE_APPLICATION

inherit
	EL_INSTALLABLE_APPLICATION

feature {NONE} -- Constants

	Option_name: IMMUTABLE_STRING_8
		once
			Result := Standard_option.main
		end

end