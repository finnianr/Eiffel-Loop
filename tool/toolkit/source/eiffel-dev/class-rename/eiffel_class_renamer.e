note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 10:37:49 GMT (Tuesday 25th June 2013)"
	revision: "2"

class
	EIFFEL_CLASS_RENAMER

inherit
	EIFFEL_CLASS_NAME_EDITOR
		rename
			make as make_editor
		redefine
			on_class_reference, on_class_name, class_identifier, edit_file
		end

create
	make

feature {NONE} -- Initialization

	make (a_old_class_name, a_new_class_name: like old_class_name)
			--
		do
			make_editor
			old_class_name := a_old_class_name
			new_class_name := a_new_class_name
		end

feature -- Basic operations

	edit_file
			--
		do
			Precursor
			set_pattern_changed
		end

feature {NONE} -- Patterns

	class_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				string_literal (old_class_name),
				not all_of (<< class_identifier_character >>)
			>> )
		end

feature {NONE} -- Events

	on_class_name (text: EL_STRING_VIEW)
			--
		do
			set_class_name (new_class_name)
			put_string (new_class_name)
		end

	on_class_reference (text: EL_STRING_VIEW)
			--
		do
			put_string (new_class_name)
		end

feature {NONE} -- Implementation

	old_class_name: STRING

	new_class_name: STRING

end

