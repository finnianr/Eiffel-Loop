note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:25:21 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_DESKTOP_MENU_ITEM

create
	make, make_standard

feature {NONE} -- Initialization

	make (a_name, a_comment: like name; a_icon_path: EL_FILE_PATH)
			--
		do
			name := a_name
			comment := a_comment
			icon_path := a_icon_path
		end

	make_standard (a_name: like name)
			--
		do
			name := a_name
			create comment.make_empty
			create icon_path
			is_standard := True
		end

feature -- Access

	icon_path: EL_FILE_PATH

	name: EL_ASTRING

	comment: EL_ASTRING

feature -- Status query

	is_standard: BOOLEAN

feature -- Element change

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		end

end
