note
	description: "[
		Translation table for multiple languages with each key having a language code
		prefix: `en. de. fr.' for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:27:24 GMT (Sunday 22nd September 2024)"
	revision: "7"

deferred class
	EL_MULTI_LANGUAGE_TRANSLATION_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			put as put_table
		redefine
			make_equal
		end

	EL_LOCALE_CONSTANTS; EL_CHARACTER_32_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_SHARED_KEY_LANGUAGE

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
		do
			Precursor (n)
			create language_set.make_equal (5)
			language_set.put (Key_language)
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		deferred
		ensure
			no_missing_translations: count \\ language_set.count = 0
		end

	make_from_source (xml: READABLE_STRING_8)
		deferred
		ensure
			no_missing_translations: count \\ language_set.count = 0
		end

feature -- Access

	key_list_for (language: STRING): EL_ZSTRING_LIST
		do
			create Result.make (count // language_set.count)
			from start until after loop
				if iteration_item_is (language) then
					Result.extend (key_for_iteration)
				end
				forth
			end
		end

	language_for_iteration: STRING
		do
			if after then
				Result := Empty_string_8

			elseif attached key_for_iteration as key and then language_set_has_key (key) then
				Result := language_set.found_item
			else
				Result := Empty_string_8
			end
		end

	language_set: EL_HASH_SET [STRING]

	missing_translation_list: EL_ZSTRING_LIST
		do
			create Result.make (0)
			across key_list_for (Key_language) as key loop
				if attached Buffer.copied (key.item) as buffer_key then
					across language_set as set loop
						if set.item /~ Key_language then
							buffer_key.replace_substring_general (set.item, 1, 2)
							if not has (buffer_key) then
								Result.extend (buffer_key.twin)
							end
						end
					end
				end
			end
		end

feature -- Status query

	iteration_item_is (language: STRING): BOOLEAN
		do
			if attached key_for_iteration as key
				and then key.count > 3 and then key.item_8 (3) = '.'
			then
				Result := key.item_8 (1) = language [1] and key.item_8 (2) = language [2]
			end
		end

feature -- Conversion

	as_utf_8_manifest_for (language: STRING): STRING
		-- textual representation encoded as UTF-8
		-- 	key_1 := value_1
		-- 	key_2 := value_2
		local
			start_index: INTEGER
		do
			create Result.make (manifest_byte_count_for (language))
			from start until after loop
				if iteration_item_is (language) then
					if Result.count > 0 then
						Result.append_character ('%N')
					end
					if attached key_for_iteration as key then
						start_index := Result.count + 1
						key.append_to_utf_8 (Result)
					-- remove language prefix "en.", "de." etc
						Result.remove_substring (start_index, start_index + 2)
					end
					Result.append_character (':')
					if item_for_iteration.has ('%N') then
						across item_for_iteration.split ('%N') as list loop
							Result.append (New_line_tab)
							list.item.append_to_utf_8 (Result)
						end
					else
						Result.append (New_line_tab)
						item_for_iteration.append_to_utf_8 (Result)
					end
				end
				forth
			end
		ensure
			calculated_correct_size: Result.capacity = Result.count
		end

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

	language_set_has_key (key: ZSTRING): BOOLEAN
		do
			if key.count > 2 then
				Language_key [1] := key.item_8 (1)
				Language_key [2] := key.item_8 (2)
				Result := language_set.has_key (Language_key)
			end
		end

	manifest_byte_count_for (language: STRING): INTEGER
		local
			text_count, line_count, new_line_count: INTEGER
		do
			from start until after loop
				if iteration_item_is (language) and then attached item_for_iteration as item_text then
					new_line_count := item_text.occurrences ('%N')
					text_count := text_count + key_for_iteration.utf_8_byte_count + item_text.utf_8_byte_count - new_line_count - 3
					line_count := new_line_count + 2
				end
				forth
			end
			Result := text_count + line_count * 2 - 1
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

	Language_key: STRING
		once
			create Result.make_filled (' ', 2)
		end

	New_line_tab: STRING = "%N%T"

end