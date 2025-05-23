note
	description: "Implementation routines for ${EL_ZCODEC}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 11:37:24 GMT (Sunday 20th April 2025)"
	revision: "18"

class
	EL_ZCODEC_BASE

inherit
	EL_ENCODING_BASE
		rename
			make as make_encodeable,
			set_default as set_default_encoding,
			utf_8 as utf_8_encoding
		redefine
			set_default_encoding
		end

	EL_ZCODE_CONVERSION
		rename
			z_code_to_unicode as multi_byte_z_code_to_unicode
		end

	EL_UC_ROUTINES_I
		rename
			utf_8_byte_count as character_utf_8_byte_count
		end

	EL_CASE_CONTRACT

	EL_STRING_HANDLER
	
	EL_SHARED_CHARACTER_AREA_ACCESS

	EL_MODULE_NAMING

	EL_SHARED_STRING_8_BUFFER_POOL

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	latin_set_from_array (array: ARRAY [INTEGER]): SPECIAL [CHARACTER]
		do
			create Result.make_empty (array.count)
			across array as c loop
				Result.extend (c.item.to_character_8)
			end
		end

	set_default_encoding
		-- derive encoding from generator class name
		do
			set_from_name (Naming.class_as_kebab_upper (Current, 1, 1))
		ensure then
			valid_encoding: encoding > 0
		end

	single_byte_unicode_chars: SPECIAL [CHARACTER_32]
		local
			i: INTEGER
		do
			create Result.make_filled ('%U', 256)
			from i := 0 until i > 255 loop
				Result [i] := i.to_character_32
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	latin_characters: SPECIAL [CHARACTER]

	shared_interval_list: EL_ARRAYED_INTERVAL_LIST
		-- initialized from {EL_ZSTRING_BASE}.Once_interval_list

feature {NONE} -- Constants

	Unicode_buffer: EL_STRING_32
		once
			create Result.make_empty
		end

end