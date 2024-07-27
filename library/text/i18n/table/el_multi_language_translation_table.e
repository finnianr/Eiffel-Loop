note
	description: "[
		Translation table for multiple languages with each key having a language code
		prefix: `en. de. fr.' for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 12:17:39 GMT (Saturday 27th July 2024)"
	revision: "1"

deferred class
	EL_MULTI_LANGUAGE_TRANSLATION_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			make as make_assignments,
			put as put_table
		redefine
			make_equal
		end

	EL_LOCALE_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	EL_SHARED_KEY_LANGUAGE

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
		do
			Precursor (n)
			create language_set.make (5)
			language_set.put (Key_language)
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		deferred
		end

	make_from_source (xml: READABLE_STRING_8)
		deferred
		end

feature -- Access

	key_list_for (language: STRING): EL_ZSTRING_LIST
		do
			create Result.make (count // language_set.count)
			from start until after loop
				if language ~ language_for_iteration then
					Result.extend (key_for_iteration)
				end
				forth
			end
		end

	language_for_iteration: ZSTRING
		do
			if after then
				create Result.make_empty

			elseif attached key_for_iteration as key and then key.count > 2
				and then language_set.has_key (buffer.copied_substring (key, 1, 2))
			then
				Result := language_set.found_item
			else
				create Result.make_empty
			end
		end

	language_set: EL_HASH_SET [STRING]

feature -- Basic operations

	append_to_items_list (list: EL_TRANSLATION_ITEMS_LIST)
		local
			l_item: EL_TRANSLATION_ITEM
		do
			list.grow (count)
			from start until after loop
				create l_item.make (key_for_iteration, item_for_iteration)
				list.extend (l_item)
				forth
			end
		end

feature -- Element change

	put (language: STRING; text, key: ZSTRING)
		require
			valid_code: language.count = 2
		do
			-- Normalize identifier for reflective localization attribute
			if key.starts_with_character ('{')
				and then key.has ('-')
				and then (key.ends_with_character ('}') or else key.has_substring (Brace_colon))
			then
				key.replace_character ('-', '_')
				key.to_lower
			end
			put_table (text, dot.joined (language, key))
			language_set.put (language)
		end

feature {NONE} -- Implementation

	is_translatable (id: ZSTRING): BOOLEAN
		-- `True' if `id' is a translatable sentence
		do
			Result := not id.has_enclosing ('{', '}')
		end

	quantifier_suffix (name: STRING): detachable STRING
		local
			index: INTEGER
		do
			index := Quantifier_names.index_of (name, 1)
			if index > 0 then
				Result := Number_suffix [index - 1]
			end
		end

feature {NONE} -- Constants

	Brace_colon: STRING = "}:"
end