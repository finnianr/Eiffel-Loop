note
	description: "[
		Z-code escape table for use with class [$source EL_ZSTRING]. See routine `escape'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-17 11:34:22 GMT (Sunday 17th June 2018)"
	revision: "5"

class
	EL_ZSTRING_UNESCAPER

inherit
	HASH_TABLE [NATURAL, NATURAL]
		rename
			make as make_table
		export
			{NONE} all
		end

	EL_SHARED_ZCODEC
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (escape_character: CHARACTER_32; table: HASH_TABLE [CHARACTER_32, CHARACTER_32])
		-- make from unicode tuples
		local
			l_codec: like codec; key_code, code: NATURAL
		do
			make_table (table.count + 1)
			l_codec := Codec
			from table.start until table.after loop
				key_code := l_codec.as_z_code (table.key_for_iteration)
				code := l_codec.as_z_code (table.item_for_iteration)
				extend (code, key_code)
				table.forth
			end
			escape_code := Codec.as_z_code (escape_character)
		end

feature -- Access

	numeric_sequence_count (str: EL_READABLE_ZSTRING; index: INTEGER): INTEGER
		do
		end

	sequence_count (str: EL_READABLE_ZSTRING; index: INTEGER): INTEGER
		do
			if not is_empty and then index <= str.count then
				if has_key (str.z_code (index)) then
					-- `found_item' is referenced in `unescaped_z_code'
					Result := 1
				else
					Result := numeric_sequence_count (str, index)
				end
			end
		end

	unescaped_z_code (str: EL_READABLE_ZSTRING; index, a_sequence_count: INTEGER): NATURAL
		do
			if a_sequence_count = 1 and then found then
				Result := found_item
			end
		end

feature -- Element change

	set_escape_character (escape_character: CHARACTER_32)
		do
			remove (escape_code)
			escape_code := Codec.as_z_code (escape_character)
			put (escape_code, escape_code)
		end

feature {STRING_HANDLER} -- Access

	escape_code: NATURAL
end
