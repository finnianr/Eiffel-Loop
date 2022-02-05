note
	description: "Class prefix remover"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 9:11:53 GMT (Saturday 5th February 2022)"
	revision: "9"

class
	CLASS_PREFIX_REMOVER

inherit
	CLASS_NAME_EDITOR
		rename
			make as make_editor
		redefine
			edit, on_class_reference, on_class_name, set_source_path
		end

create
	make

feature {NONE} -- Initialization

	make (a_prefix_letters: STRING)
			--
		do
			make_editor
			prefix_characters := a_prefix_letters + "_"
			prefix_characters_lower := prefix_characters.as_lower
			create class_name.make_empty
			create class_set.make (0)
		end

feature -- Element Change

  	set_source_path (a_source_path: FILE_PATH)
  		do
  			class_set.put (a_source_path.base_sans_extension.as_upper)
  			Precursor (a_source_path)
  		end

feature -- Basic operations

	edit
		do
			if source_path.base.starts_with (prefix_characters_lower) then
				Precursor
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

	prefix_characters_lower: ZSTRING

end