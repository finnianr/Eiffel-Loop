note
	description: "Z-code escape table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 12:46:34 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_ESCAPE_TABLE

inherit
	HASH_TABLE [NATURAL, NATURAL]
		rename
			make as make_table
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
			across table as character loop
				key_code := l_codec.as_z_code (character.key)
				code := l_codec.as_z_code (character.item)
				extend (code, key_code)
			end
			set_escape_character (escape_character)
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