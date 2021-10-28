note
	description: "Localized texts for [$source EL_STANDARD_UNINSTALL_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 13:26:41 GMT (Tuesday 26th October 2021)"
	revision: "4"

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

	remove_all_data_prompt: ZSTRING

feature -- Uninstall script

	app_removed_template: ZSTRING

	removing_program_files: ZSTRING

feature {NONE} -- Constants

	English_table: STRING = "[
		app_removed_template:
			"%S" removed.
		remove_all_data_prompt:
			Delete data and configuration files for all %S users (y/n)
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