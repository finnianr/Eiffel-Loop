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
	date: "2023-03-11 10:04:34 GMT (Saturday 11th March 2023)"
	revision: "6"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND

obsolete
	"Once off use"

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