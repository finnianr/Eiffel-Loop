note
	description: "Class prefix remover"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	CLASS_PREFIX_REMOVER

inherit
	CLASS_NAME_EDITOR
		rename
			make as make_editor
		redefine
			on_class_reference, on_class_name
		end

create
	make

feature {NONE} -- Initialization

	make (a_prefix_letters: like prefix_characters)
			--
		do
			make_editor
			prefix_characters := a_prefix_letters + "_"
			create class_name.make_empty
		end

feature {NONE} -- Events

	on_class_name (text: EL_STRING_VIEW)
			--
		local
			name: STRING
		do
			name := text
			if class_name.is_empty then
				if name.starts_with (prefix_characters) then
					name.remove_head (prefix_characters.count)
					set_class_name (name)
				end
			end
			put_string (name)
		end

	on_class_reference (text: EL_STRING_VIEW)
			--
		local
			name: STRING
		do
			name := text
			if name.starts_with (prefix_characters) then
				name.remove_head (prefix_characters.count)
			end
			put_string (name)
		end

feature {NONE} -- Implementation

	prefix_characters: STRING
end
