note
	description: "Localized texts for [$source EL_STANDARD_UNINSTALL_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-30 13:28:12 GMT (Wednesday 30th September 2020)"
	revision: "2"

class
	EL_UNINSTALL_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		rename
			case as Case_first_upper
		end

create
	make

feature -- Access

	uninstalling: ZSTRING

	uninstall_confirmation: ZSTRING

	first_letter_yes: CHARACTER_32
		do
			if yes.count > 0 then
				Result := yes [1]
			end
		end

	uninstall_x: ZSTRING

	uninstall: ZSTRING

	uninstall_application: ZSTRING

	uninstall_warning: ZSTRING

	yes: ZSTRING

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
		yes:
			yes
	]"

end