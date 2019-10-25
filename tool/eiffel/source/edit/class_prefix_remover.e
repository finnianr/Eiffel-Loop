note
	description: "Class prefix remover"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 10:49:08 GMT (Monday   7th   October   2019)"
	revision: "5"

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

	make (a_prefix_letters: STRING; file_path_list: LIST [EL_FILE_PATH])
			--
		do
			make_editor
			prefix_characters := a_prefix_letters + "_"
			create class_name.make_empty
			create class_set.make_equal (file_path_list.count)
			across file_path_list as path loop
				class_set.put (path.item.base_sans_extension.as_upper)
			end
		end
feature {NONE} -- Events

	on_class_name (text: EL_STRING_VIEW)
			--
		local
			name: ZSTRING
		do
			name := new_name (text)
			if class_name.is_empty and then name.count < text.count then
				set_class_name (name)
			end
			put_string (name)
		end

	on_class_reference (text: EL_STRING_VIEW)
			--
		do
			put_string (new_name (text))
		end

feature {NONE} -- Implementation

	new_name (text: EL_STRING_VIEW): ZSTRING
		do
			Result := text
			if Result.starts_with (prefix_characters) and then class_set.has (Result) then
				Result.remove_head (prefix_characters.count)
			end
		end

feature {NONE} -- Internal attributes

	class_set: EL_HASH_SET [ZSTRING]

	prefix_characters: ZSTRING

end
