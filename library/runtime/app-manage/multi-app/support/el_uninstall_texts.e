note
	description: "Localized texts for [$source EL_STANDARD_UNINSTALL_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-30 11:25:46 GMT (Monday 30th August 2021)"
	revision: "3"

class
	EL_UNINSTALL_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Texts

	uninstall: ZSTRING

	uninstall_application: ZSTRING

	uninstall_confirmation: ZSTRING

	uninstall_warning: ZSTRING

	uninstall_x: ZSTRING

	uninstalling: ZSTRING

feature {NONE} -- Constants

	English_table: STRING = "[
		uninstall_confirmation:
			If you are sure press 'y' and <return>:
		uninstall_warning:
			THIS ACTION WILL PERMANENTLY DELETE ALL YOUR DATA.
		uninstalling:
			Uninstalling:
		uninstall_application:
			Uninstall %S application
		uninstall_x:	
			Uninstall %S
	]"

end