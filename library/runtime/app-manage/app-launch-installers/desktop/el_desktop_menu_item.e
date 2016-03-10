note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-06 13:58:29 GMT (Friday 6th December 2013)"
	revision: "3"

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

	name: ASTRING

	comment: ASTRING

feature -- Status query

	is_standard: BOOLEAN

feature -- Element change

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		end

end
