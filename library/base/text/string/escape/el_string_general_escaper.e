note
	description: "String general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

deferred class
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Initialization

	make (characters: READABLE_STRING_GENERAL)
		local
			buffer: like Once_buffer; i: INTEGER; code: NATURAL
		do
			buffer := Once_buffer; wipe_out (buffer)
			buffer.append (new_characters_string (characters))
			create code_table.make (characters.count)
			from i := 1 until i > buffer.count loop
				code := buffer.code (i)
				if i = 1 then
					escape_code := code
				else
					code_table.extend (code, code)
				end
				i := i + 1
			end
		end

	make_from_table (escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32])
		local
			buffer: like Once_buffer; i: INTEGER; code: NATURAL
			character_pairs: STRING_32
		do
			create character_pairs.make (escape_table.count * 2)
			from escape_table.start until escape_table.after loop
				character_pairs.extend (escape_table.key_for_iteration)
				character_pairs.extend (escape_table.item_for_iteration)
				escape_table.forth
			end
			buffer := Once_buffer; wipe_out (buffer)
			buffer.append (new_characters_string (character_pairs))
			create code_table.make (escape_table.count)
			from i := 1 until i > buffer.count loop
				code := buffer.code (i)
				if i = 1 then
					escape_code := code
					i := i + 1
				else
					code_table.extend (buffer.code (i + 1), code)
					i := i + 2
				end
			end
		end

feature -- Conversion

	escaped (str: like READABLE; keeping_ref: BOOLEAN): like once_buffer
		do
			Result := escaped_substring (str, 1, str.count, keeping_ref)
		end

	escaped_substring (str: like READABLE; start_index, end_index: INTEGER; keeping_ref: BOOLEAN): like once_buffer
		-- escaped `str' in once buffer
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			Result := once_buffer
			wipe_out (Result)
			escape_substring_into (str, start_index, end_index, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

feature -- Basic operations

	escape_into (str: like READABLE; output: like once_buffer)
		do
			escape_substring_into (str, 1, str.count, output)
		end

	escape_substring_into (str: like READABLE; start_index, end_index: INTEGER; output: like once_buffer)
		local
			i, min_index: INTEGER; code: NATURAL
		do
			min_index := str.count.min (end_index)
			from i := start_index until i > min_index loop
				code := str.code (i)
				if is_escaped (code) then
					append_escape_sequence (output, code)
				else
					output.append_code (code)
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	code_table: HASH_TABLE [NATURAL, NATURAL]

	escape_code: NATURAL

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			str.append_code (escape_code)
			str.append_code (code_table.found_item)
		end

	is_escaped (code: NATURAL): BOOLEAN
		do
			Result := code_table.has_key (code)
		end

	new_characters_string (characters: READABLE_STRING_GENERAL): STRING_32
		do
			create Result.make (characters.count + 1)
			Result.append_character (Escape_character)
			Result.append_string_general (characters)
		end

	once_buffer: STRING_GENERAL
		deferred
		end

	wipe_out (str: like once_buffer)
		deferred
		end

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_GENERAL
		require
			never_called: False
		deferred
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER_32
		once
			Result := '\'
		end

end