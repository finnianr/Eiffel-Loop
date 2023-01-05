note
	description: "General string unescaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 16:03:45 GMT (Thursday 5th January 2023)"
	revision: "5"

deferred class
	EL_STRING_GENERAL_UNESCAPER [R -> READABLE_STRING_GENERAL, G -> STRING_GENERAL]

inherit
	HASH_TABLE [NATURAL, NATURAL]
		rename
			make as make_table
		export
			{NONE} all
		end

	STRING_HANDLER undefine copy, is_equal end

feature {NONE} -- Initialization

	make (table: EL_ESCAPE_TABLE)
		local
			key_code, code: NATURAL
		do
			make_table (table.count + 1)
			across table as char loop
				key_code := character_to_code (char.key)
				code := character_to_code (char.item)
				extend (code, key_code)
			end
			escape_code := character_to_code (table.escape_character)
		end

feature -- Access

	escape_code: NATURAL

	unescaped (str: R): G
		deferred
		end

feature -- Basic operations

	unescape (str: G)
		deferred
		end

	unescape_into (str: R; output: G)
		deferred
		end

feature -- Element change

	set_escape_character (escape_character: CHARACTER_32)
		do
			remove (escape_code)
			escape_code := character_to_code (escape_character)
			put (escape_code, escape_code)
		end

feature {NONE} -- Implementation

	character_to_code (character: CHARACTER_32): NATURAL
		do
			Result := character.natural_32_code
		end

	i_th_code (str: R; index: INTEGER): NATURAL
		do
			Result := str.code (index)
		end

	numeric_sequence_count (str: R; index: INTEGER): INTEGER
		do
		end

	sequence_count (str: R; index: INTEGER): INTEGER
		do
			if index <= str.count then
				if has_key (i_th_code (str, index)) then
					-- `found_item' is referenced in `unescaped_code'
					Result := 1
				else
					Result := numeric_sequence_count (str, index)
				end
			end
		end

	unescaped_code (index, a_sequence_count: INTEGER): NATURAL
		do
			if a_sequence_count = 1 and then found then
				Result := found_item
			end
		end

end