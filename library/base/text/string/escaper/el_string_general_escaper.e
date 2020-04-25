note
	description: "String general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-25 11:04:49 GMT (Saturday 25th April 2020)"
	revision: "6"

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
		-- escaped `str' in once buffer
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		local
			i: INTEGER; code: NATURAL; table: like code_table
		do
			Result := once_buffer
			wipe_out (Result)
			table := code_table
			from i := 1 until i > str.count loop
				code := str.code (i)
				table.search (code)
				if is_escaped (table, code) then
					append_escape_sequence (Result, table.found_item)
				else
					Result.append_code (code)
				end
				i := i + 1
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Internal attributes

	code_table: HASH_TABLE [NATURAL, NATURAL]

	escape_code: NATURAL

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			str.append_code (escape_code)
			str.append_code (code)
		end

	is_escaped (table: like code_table; code: NATURAL): BOOLEAN
		do
			Result := table.found
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
