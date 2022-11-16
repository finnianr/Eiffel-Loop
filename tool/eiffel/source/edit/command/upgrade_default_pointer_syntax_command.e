note
	description: "[
		Command to change syntax of default_pointers references:
		
		**From**
			ptr /= default_pointer 
		**To new**
			is_attached (ptr)

		**From**
			ptr = default_pointer
		**To new**
			not is_attached (ptr)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND

create
	make

feature -- Constants

	Description: STRING = "[
		Change syntax of default_pointer references:

			ptr /= default_pointer TO is_attached (ptr)
			ptr = default_pointer TO not is_attached (ptr)
	]"

feature {NONE} -- Implementation

	new_editor: UPGRADE_DEFAULT_POINTER_SYNTAX_EDITOR
		do
			create Result.make
		end

end