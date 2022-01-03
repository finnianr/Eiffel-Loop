note
	description: "Desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "11"

class
	EL_DESKTOP_MENU_ITEM

inherit
	EL_ZSTRING_CONSTANTS

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

create
	make, make_standard, make_default

feature {NONE} -- Initialization

	make (a_name, a_comment: READABLE_STRING_GENERAL; a_icon_path: FILE_PATH)
			--
		do
			name := new_zstring (a_name); comment := new_zstring (a_comment)
			icon_path := a_icon_path
		end

	make_default
		do
			create icon_path
			comment := Empty_string
		end

	make_standard (a_name: READABLE_STRING_GENERAL)
			--
		do
			make_default
			create name.make_from_general (a_name)
			is_standard := True
		end

feature -- Access

	comment: ZSTRING

	icon_path: FILE_PATH

	name: ZSTRING

	windows_icon_path: FILE_PATH
		do
			Result := icon_path.with_new_extension ("ico")
		end

feature -- Status query

	is_standard: BOOLEAN

feature -- Element change

	set_name (a_name: like name)
		do
			name := a_name
		end

end