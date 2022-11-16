note
	description: "Desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	EL_DESKTOP_MENU_ITEM

create
	make, make_standard, make_default

feature {NONE} -- Initialization

	make (a_name, a_comment: READABLE_STRING_GENERAL; a_icon_path: FILE_PATH)
			--
		do
			make_default
			name.append_string_general (a_name); comment.append_string_general (a_comment)
			icon_path := a_icon_path
		end

	make_default
		do
			create icon_path
			create comment.make_empty
			create name.make_empty
		end

	make_standard (a_name: READABLE_STRING_GENERAL)
			--
		do
			make_default
			name.append_string_general (a_name)
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

	set_name (a_name: READABLE_STRING_GENERAL)
		do
			name.wipe_out
			name.append_string_general (a_name)
		end

end