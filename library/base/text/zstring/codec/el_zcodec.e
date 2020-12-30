note
	description: "Base class for Latin, Windows and UTF-8 codecs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-30 11:18:19 GMT (Wednesday 30th December 2020)"
	revision: "17"

deferred class
	EL_ZCODEC

inherit
	EL_ENCODING_BASE
		rename
			make as make_encodeable,
			set_default as set_default_encoding
		redefine
			set_default_encoding
		end

	STRING_HANDLER

	EL_SHARED_ONCE_STRING_8

	EL_ZCODE_CONVERSION
		rename
			z_code_to_unicode as multi_byte_z_code_to_unicode
		end

	EL_MODULE_NAMING

feature {EL_ZCODEC_FACTORY} -- Initialization

	make
		do
			make_default
			create latin_characters.make_filled ('%U', 1)
			unicode_table := new_unicode_table
			initialize_latin_sets
		end

	set_default_encoding
		-- derive encoding from generator class name
		do
			set_from_name (Naming.class_as_kebab_upper (Current, 1, 1))
		ensure then
			valid_encoding: encoding > 0
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		deferred
		end

	is_alphanumeric (code: NATURAL): BOOLEAN
		do
			Result := is_numeric (code) or else is_alpha (code)
		end

	is_lower (code: NATURAL): BOOLEAN
		deferred
		end

	is_numeric (code: NATURAL): BOOLEAN
		do
			inspect code
				when 48..57 then
					Result := True
			else
			end
		end

	is_upper (code: NATURAL): BOOLEAN
		deferred
		end

feature {EL_SHARED_ZSTRING_CODEC, EL_ENCODING_BASE} -- Access

	unicode_table: like new_unicode_table
		-- map latin to unicode

feature -- Basic operations

	append_encoded_to_string_8 (unicode_in: READABLE_STRING_GENERAL; output: STRING)
		local
			l_area: SPECIAL [CHARACTER]; i, count: INTEGER
		do
			count := unicode_in.count
			l_area := encoded_latin_out (unicode_in, count).area
			from i := 0 until i = count loop
				output.extend (l_area [i])
				i := i + 1
			end
		end

	decode (a_count: INTEGER; latin_in: SPECIAL [CHARACTER]; unicode_out: SPECIAL [CHARACTER_32]; out_offset: INTEGER)
			-- Replace Ctrl characters used as place holders for foreign characters with original unicode characters.
			-- If 'a_decode' is true encode output as unicode
			-- Result is count of unencodeable Unicode characters
		require
			enough_latin_characters: latin_in.count > a_count
			unicode_out_big_enough: unicode_out.count > a_count + out_offset
		local
			i, code: INTEGER; c: CHARACTER; l_unicodes: like unicode_table
		do
			l_unicodes := unicode_table
			from i := 0 until i = a_count loop
				c := latin_in [i]; code := c.code
				if c /= Unencoded_character then
					unicode_out [i + out_offset] := l_unicodes [code]
				end
				i := i + 1
			end
		end

	encode (
		unicode_in: READABLE_STRING_GENERAL; latin_out: SPECIAL [CHARACTER]; out_offset: INTEGER;
		unencoded_characters: EL_EXTENDABLE_UNENCODED_CHARACTERS
	)
		-- encode unicode characters as latin
		-- Set unencodeable characters as the Substitute character (26) and record location in unencoded_intervals
		require
			latin_out_big_enough: latin_out.count >= unicode_in.count
			valid_offset_and_count: unicode_in.count > 0 implies latin_out.valid_index (unicode_in.count + out_offset - 1)
		local
			i, count, unicode: INTEGER; uc: CHARACTER_32; c: CHARACTER; l_unicodes: like unicode_table
		do
			l_unicodes := unicode_table; count := unicode_in.count
			from i := 1 until i > count loop
				uc := unicode_in [i]; unicode := uc.code
				if unicode <= 255 and then l_unicodes [unicode] = uc then
					latin_out [i + out_offset - 1] := uc.to_character_8
				else
					c := latin_character (uc, unicode)
					if c.code = 0 then
						latin_out [i + out_offset - 1] := Unencoded_character
						unencoded_characters.extend (unicode.to_natural_32, i + out_offset)
					else
						latin_out [i + out_offset - 1] := c
					end
				end
				i := i + 1
			end
		end

	to_lower (
		characters: SPECIAL [CHARACTER]; start_index, end_index: INTEGER; unencoded_characters: EL_UNENCODED_CHARACTERS
	)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			change_case (characters, start_index, end_index, False, unencoded_characters)
		end

	to_upper (
		characters: SPECIAL [CHARACTER]; start_index, end_index: INTEGER; unencoded_characters: EL_UNENCODED_CHARACTERS
	)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			change_case (characters, start_index, end_index, True, unencoded_characters)
		end

	write_encoded (unicode_in: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		local
			l_area: SPECIAL [CHARACTER]; i, count: INTEGER
		do
			count := unicode_in.count
			l_area := encoded_latin_out (unicode_in, count).area
			from i := 0 until i = count loop
				writeable.write_raw_character_8 (l_area [i])
				i := i + 1
			end
		end

	write_encoded_character (uc: CHARACTER_32; writeable: EL_WRITEABLE)
		do
			writeable.write_raw_character_8 (encoded_character (uc.natural_32_code))
		end

feature -- Conversion

	as_unicode (encoded: READABLE_STRING_8; keeping_ref: BOOLEAN): READABLE_STRING_GENERAL
		-- returns `encoded' string as unicode assuming the encoding matches `Current' codec
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			if encoded_as_latin (1) then
				Result := encoded
			else
				Unicode_buffer.set_from_encoded (Current, encoded)
				Result := Unicode_buffer
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	as_unicode_character (c: CHARACTER): CHARACTER_32
		do
			Result := unicode_table [c.code]
		end

	as_z_code (uc: CHARACTER_32): NATURAL
			-- Returns hybrid code of latin and unicode
			-- Single byte codes are reserved for latin encoding.
			-- Unicode characters below 0xFF are shifted into the private use range: 0xE000 .. 0xF8FF
			-- See https://en.wikipedia.org/wiki/Private_Use_Areas
		local
			c: CHARACTER; unicode: NATURAL
		do
			unicode := uc.natural_32_code
			if unicode <= 255 and then unicode_table [unicode.to_integer_32] = uc then
				Result := unicode
			else
				c := latin_character (uc, unicode.to_integer_32)
				if c.code = 0 then
					Result := unicode_to_z_code (unicode)
				else
					Result := c.natural_32_code
				end
			end
		end

	encoded_character (unicode: NATURAL_32): CHARACTER
		local
			uc: CHARACTER_32; index: INTEGER
		do
			uc := unicode.to_character_32; index := unicode.to_integer_32
			if unicode <= 255 and then unicode_table [index] = uc then
				Result := uc.to_character_8
			else
				Result := latin_character (uc, index)
				if Result.code = 0 then
					Result := Unencoded_character
				end
			end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in current set
		deferred
		ensure
			valid_latin: Result /= '%U' implies unicode_table [Result.code] = uc
		end

	z_code_as_unicode (z_code: NATURAL): NATURAL
		do
			if z_code > 0xFF then
				Result := multi_byte_z_code_to_unicode (z_code)
			else
				Result := unicode_table.item (z_code.to_integer_32).natural_32_code
			end
		end

feature {EL_ZSTRING} -- Implementation

	as_lower (code: NATURAL): NATURAL
		deferred
		ensure then
			reversible: code /= Result implies code = as_upper (Result)
		end

	as_upper (code: NATURAL): NATURAL
		deferred
		ensure then
			reversible: code /= Result implies code = as_lower (Result)
		end

	change_case (
		latin_array: SPECIAL [CHARACTER]; start_index, end_index: INTEGER; change_to_upper: BOOLEAN
		unencoded_characters: EL_UNENCODED_CHARACTERS
	)
		local
			unicode_substitute: CHARACTER_32; c, new_c: CHARACTER; i: INTEGER
		do

			from i := start_index until i > end_index loop
				c := latin_array [i]
				if c /= Unencoded_character then
					if change_to_upper then
						new_c := as_upper (c.natural_32_code).to_character_8
					else
						new_c := as_lower (c.natural_32_code).to_character_8
					end
					if c >= '~' and then new_c = c then
						unicode_substitute := unicode_case_change_substitute (c.natural_32_code)
						if unicode_substitute.natural_32_code > 0 then
							new_c := Unencoded_character
							unencoded_characters.put_code (unicode_substitute.natural_32_code, i + 1)
						end
					end
					if new_c /= c then
						latin_array [i] := new_c
					end
				end
				i := i + 1
			end
		end

	encoded_latin_out (unicode_in: READABLE_STRING_GENERAL; count: INTEGER): STRING
		local
			extendible_unencoded: like Once_extendible_unencoded
		do
			extendible_unencoded := Once_extendible_unencoded
			extendible_unencoded.wipe_out

			Result := empty_once_string_8
			Result.grow (count)
			Result.set_count (count)
			encode (unicode_in, Result.area, 0, extendible_unencoded)
		end

	initialize_latin_sets
		deferred
		end

	latin_set_from_array (array: ARRAY [INTEGER]): SPECIAL [CHARACTER]
		do
			create Result.make_empty (array.count)
			across array as c loop
				Result.extend (c.item.to_character_8)
			end
		end

	new_unicode_table: SPECIAL [CHARACTER_32]
			-- map latin to unicode
		deferred
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

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		deferred
		end

feature {NONE} -- Internal attributes

	latin_characters: SPECIAL [CHARACTER]

feature {NONE} -- Constants

	Once_extendible_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
		local
			unencoded: EL_UNENCODED_CHARACTERS
		once
			create unencoded.make
			Result := unencoded.Once_extendible_unencoded
		end

	Unicode_buffer: EL_STRING_32
		once
			create Result.make_empty
		end

end