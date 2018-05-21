note
	description: "Class renamer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	CLASS_RENAMER

inherit
	CLASS_NAME_EDITOR
		rename
			make as make_editor
		redefine
			on_class_reference, on_class_name, class_name_pattern, edit
		end

create
	make

feature {NONE} -- Initialization

	make (a_old_class_name, a_new_class_name: like old_class_name)
			--
		do
			old_class_name := a_old_class_name; new_class_name := a_new_class_name
			make_editor
		end

feature -- Basic operations

	edit
			--
		do
			Precursor
			set_pattern_changed
		end

feature {NONE} -- Patterns

	class_name_pattern: like all_of
			--
		do
			Result := all_of ( <<
				string_literal (old_class_name),
				not all_of (<< class_name_character >>)
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

	old_class_name: ZSTRING

	new_class_name: ZSTRING

end
