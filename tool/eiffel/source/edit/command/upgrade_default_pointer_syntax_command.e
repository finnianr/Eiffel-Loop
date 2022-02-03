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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 12:53:04 GMT (Thursday 3rd February 2022)"
	revision: "4"

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