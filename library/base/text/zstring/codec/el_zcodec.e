note
	description: "Base class for Latin, Windows and UTF-8 codecs"
	notes: "Proven to be thread-safe in repository publishing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-28 10:51:54 GMT (Friday 28th April 2023)"
	revision: "52"

deferred class
	EL_ZCODEC

inherit
	EL_ZCODEC_IMPLEMENTATION
		export
			{EL_ZSTRING_IMPLEMENTATION} shared_interval_list
		end

feature {EL_ZCODEC_FACTORY} -- Initialization

	make
		do
			make_default
			create latin_characters.make_filled ('%U', 1)
			unicode_table := new_unicode_table
			shared_interval_list := Empty_string.Once_interval_list
			create accumulator.make_empty (25)
			initialize_latin_sets
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

	same_caseless_characters (area, other_area: SPECIAL [CHARACTER]; other_offset, start_index, count: INTEGER): BOOLEAN
		local
			i, j: INTEGER; c: CHARACTER
		do
			Result := True
			from i := 0 until not Result or i = count loop
				j := start_index + i
				c := area [j]
				if c = Substitute then
					Result := other_area [j + other_offset] = Substitute
				else
					Result := same_caseless (c, other_area [j + other_offset], '%U')
				end
				i := i + 1
			end
		end

	same_caseless (a, b: CHARACTER; b_unicode: CHARACTER_32): BOOLEAN
		-- `True' if `a' and `b' are same character regardless of case
		require
			valid_caseless: valid_caseless_argument (b, b_unicode)
		local
			unicode_substitute: CHARACTER_32; case_offset: INTEGER
			a_code: NATURAL; a_is_upper, a_is_lower: BOOLEAN
		do
			if a = b then
				Result := True
			else
				a_code := a.natural_32_code
				if is_lower (a_code) then
					case_offset := to_upper_offset (a_code)
					a_is_lower := True

				elseif is_upper (a_code) then
					case_offset := to_lower_offset (a_code)
					a_is_upper := True
				end
				if case_offset.to_boolean then
					Result := a + case_offset = b

				elseif a_is_lower or a_is_upper then
					unicode_substitute := unicode_case_change_substitute (a_code)
					if unicode_substitute > '%U' then
						Result := unicode_substitute = b_unicode
					end
				end
			end
		end

feature -- Contract Support

	is_encodeable_as_string_8 (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if contents of `str' is encodeable as a single-byte string
		require
			valid_start_index: str.valid_index (start_index) and str.valid_index (end_index)
		local
			i, code_i, in_offset, block_index: INTEGER; uc_i: CHARACTER_32; c_i: CHARACTER
			unicode, zstring_unicode: like unicode_table; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if attached str.area as area and then attached str.unencoded_area as area_32 then
				unicode := unicode_table; zstring_unicode := str.codec.unicode_table
				in_offset := str.area_lower
				Result := True
				if unicode = zstring_unicode then
					Result := not str.has_mixed_encoding
				else
					from i := start_index until not Result or i > end_index loop
						c_i := area [i + in_offset - 1]
						if c_i = Substitute then
							uc_i := iter.item ($block_index, area_32, i)
						else
							uc_i := zstring_unicode [c_i.code]
						end
						code_i := uc_i.code

						if code_i <= Max_7_bit_code then
							do_nothing

						elseif code_i <= Max_8_bit_code and then unicode [code_i] = uc_i then
							do_nothing

						else
							Result := latin_character (uc_i) /=  '%U'
						end
						i := i + 1
					end
				end
			end
		end

	valid_offset_and_count (source_count: INTEGER; encoded_out: SPECIAL [CHARACTER]; out_offset: INTEGER;): BOOLEAN
		do
			if encoded_out.count >= source_count then
				Result := source_count > 0 implies encoded_out.valid_index (source_count + out_offset - 1)
			end
		end

	valid_caseless_argument (b: CHARACTER; b_unicode: CHARACTER_32): BOOLEAN
		do
			if b = Substitute then
				Result := b_unicode.code.to_boolean
			else
				Result := b_unicode = '%U'
			end
		end

feature {EL_SHARED_ZSTRING_CODEC, EL_ENCODING_BASE, STRING_HANDLER} -- Access

	empty_accumulator: like accumulator
		do
			Result := accumulator
			Result.wipe_out
		end

	order_comparison (a_zcode, b_zcode: NATURAL): INTEGER
		-- Comparison must be done as unicode and never Latin-X or Windows-X
		do
			Result := z_code_as_unicode (b_zcode).to_integer_32 - z_code_as_unicode (a_zcode).to_integer_32
		end

	unicode_table: like new_unicode_table
		-- map latin to unicode

feature -- Encoding operations

	append_encoded_to (str: READABLE_STRING_8; output: ZSTRING)
		-- append `str' encoded with `encoding' to `output'
		do
			if encoded_as_latin (1) then
				output.append_string_general (str)
			else
				Unicode_buffer.set_from_encoded (Current, str)
				output.append_string_general (Unicode_buffer)
			end
		end

	append_encoded_to_string_8 (unicode_in: READABLE_STRING_GENERAL; output: STRING)
		local
			offset, new_count: INTEGER
		do
			offset := output.count
			new_count := offset + unicode_in.count
			output.grow (new_count)
			output.set_count (new_count)
			encode_substring (unicode_in, output.area, 1, unicode_in.count, offset, shared_interval_list.emptied)
		end

	encode (
		unicode_in: READABLE_STRING_GENERAL; encoded_out: SPECIAL [CHARACTER]; out_offset: INTEGER;
		unencoded_intervals: EL_ARRAYED_INTERVAL_LIST
	)
		do
			encode_substring (unicode_in, encoded_out, 1, unicode_in.count, out_offset, unencoded_intervals)
		end

	encode_as_string_8 (unicode_in: READABLE_STRING_GENERAL; encoded_out: SPECIAL [CHARACTER]; out_offset: INTEGER)
		do
			encode (unicode_in, encoded_out, out_offset, shared_interval_list.emptied)
		end

	encode_substring (
		unicode_in: READABLE_STRING_GENERAL; encoded_out: SPECIAL [CHARACTER]
		start_index, end_index, out_offset: INTEGER
		unencoded_intervals: EL_ARRAYED_INTERVAL_LIST
	)
		-- encode general `unicode_in' characters as current `encoding'
		-- Set unencodeable characters as the `Substitute' character (26) and record location in `unencoded_intervals'
		require
			valid_offset_and_count: valid_offset_and_count (end_index - start_index + 1, encoded_out, out_offset)
			empty_intervals: unencoded_intervals.is_empty
		local
			i, out_i, code_i, in_offset: INTEGER; c: CHARACTER
			c_8_area: SPECIAL [CHARACTER_8]; unicode: like unicode_table
		do
			if attached {READABLE_STRING_8} unicode_in as s_8 and then attached cursor_8 (s_8) as c_8 then
				unicode := unicode_table; in_offset := c_8.area_first_index
				c_8_area := c_8.area
				from i := start_index until i > end_index loop
					c := c_8_area [i + in_offset - 1]; code_i := c.code
					out_i := i + out_offset - start_index

					if code_i <= Max_7_bit_code or else unicode [code_i].to_character_8 = c then
						encoded_out [out_i] := c
					else
						c := latin_character (c)
						if c = '%U' then
							encoded_out [out_i] := Substitute
							unencoded_intervals.extend_upper (out_i + 1)
						else
							encoded_out [out_i] := c
						end
					end
					i := i + 1
				end

			elseif attached {READABLE_STRING_32} unicode_in as str_32 then
				encode_substring_32 (str_32, encoded_out, start_index, end_index, out_offset, unencoded_intervals)
			end
		end

	encode_substring_32 (
		unicode_in: READABLE_STRING_32; encoded_out: SPECIAL [CHARACTER]
		start_index, end_index, out_offset: INTEGER
		unencoded_intervals: EL_ARRAYED_INTERVAL_LIST
	)
		-- encode `unicode_in' characters as current `encoding'
		-- Set unencodeable characters as the `Substitute' character (26) and record location in `unencoded_intervals'
		require
			valid_offset_and_count: valid_offset_and_count (end_index - start_index + 1, encoded_out, out_offset)
		local
			i, out_i, code_i, in_offset: INTEGER; uc: CHARACTER_32; c: CHARACTER
			unicode: like unicode_table
		do
			if attached {EL_READABLE_ZSTRING} unicode_in as zstr then
				encode_sub_zstring (zstr, encoded_out, start_index, end_index, out_offset, unencoded_intervals)

			elseif attached cursor_32 (unicode_in) as c_32 and then attached c_32.area as c_32_area then
				unicode := unicode_table; in_offset := c_32.area_first_index

				from i := start_index until i > end_index loop
					uc := c_32_area [i + in_offset - 1]; code_i := uc.code
					out_i := i + out_offset - start_index

					if code_i <= Max_7_bit_code then
						encoded_out [out_i] := uc.to_character_8

					elseif code_i <= Max_8_bit_code and then unicode [code_i] = uc then
						encoded_out [out_i] := uc.to_character_8

					else
						c := latin_character (uc)
						if c = '%U' then
							encoded_out [out_i] := Substitute
							unencoded_intervals.extend_upper (out_i + 1)
						else
							encoded_out [out_i] := c
						end
					end
					i := i + 1
				end
			end
		end

	encode_sub_zstring (
		zstr_in: EL_READABLE_ZSTRING; encoded_out: SPECIAL [CHARACTER]
		start_index, end_index, out_offset: INTEGER
		unencoded_intervals: EL_ARRAYED_INTERVAL_LIST
	)
		-- encode `unicode_in' characters as current `encoding'
		-- Set unencodeable characters as the `Substitute' character (26) and record location in `unencoded_intervals'
		require
			valid_offset_and_count: valid_offset_and_count (end_index - start_index + 1, encoded_out, out_offset)
		local
			i, out_i, code_i, in_offset, block_index, count: INTEGER; uc_i: CHARACTER_32; c_i: CHARACTER
			unicode, zstring_unicode: like unicode_table; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if attached zstr_in.area as area and then attached zstr_in.unencoded_area as area_32 then
				unicode := unicode_table; zstring_unicode := zstr_in.codec.unicode_table
				in_offset := zstr_in.area_lower
				if unicode = zstring_unicode then
					-- same encoding
					count := end_index - start_index + 1
					encoded_out.copy_data (area, start_index + in_offset - 1, out_offset, count)
					if zstr_in.has_mixed_encoding then
						from i := start_index until i > end_index loop
							c_i := area [i + in_offset - 1]
							if c_i = Substitute then
								out_i := i + out_offset - start_index
								unencoded_intervals.extend_upper (out_i + 1)
							end
							i := i + 1
						end
					end
				else
					from i := start_index until i > end_index loop
						c_i := area [i + in_offset - 1]
						if c_i = Substitute then
							uc_i := iter.item ($block_index, area_32, i)
						else
							uc_i := zstring_unicode [c_i.code]
						end
						code_i := uc_i.code
						out_i := i + out_offset - start_index

						if code_i <= Max_7_bit_code then
							encoded_out [out_i] := uc_i.to_character_8

						elseif code_i <= Max_8_bit_code and then unicode [code_i] = uc_i then
							encoded_out [out_i] := uc_i.to_character_8

						else
							c_i := latin_character (uc_i)
							if c_i = '%U' then
								encoded_out [out_i] := Substitute
								unencoded_intervals.extend_upper (out_i + 1)
							else
								encoded_out [out_i] := c_i
							end
						end
						i := i + 1
					end
				end
			end
		end

	encode_utf (
		utf_in: READABLE_STRING_8; encoded_out: SPECIAL [CHARACTER]; utf_type, unicode_count, out_offset: INTEGER
		unencoded_characters: EL_UNENCODED_CHARACTERS_BUFFER
	)
		-- encode unicode characters as latin
		-- Set unencodeable characters as the Substitute character (26) and record location in unencoded_intervals
		require
			valid_utf_type: utf_type = 8 or utf_type = 16
			valid_utf_16_input: utf_type = 16 implies utf_in.count \\ 2 = 0
			valid_offset_and_count: valid_offset_and_count (unicode_count, encoded_out, out_offset)
		local
			i, j, byte_count, end_index: INTEGER; leading_byte, unicode, code_1: NATURAL
			uc: CHARACTER_32; c: CHARACTER; area: SPECIAL [CHARACTER]
			l_unicodes: like unicode_table; is_utf_8_in: BOOLEAN
			utf_8: EL_UTF_8_CONVERTER; utf_16_le: EL_UTF_16_LE_CONVERTER
		do
			l_unicodes := unicode_table; is_utf_8_in := utf_type = 8
			if attached cursor_8 (utf_in) as cursor then
				area := cursor.area; end_index := cursor.area_last_index
				from i := cursor.area_first_index; j := out_offset until i > end_index loop
					if is_utf_8_in then
						leading_byte := area [i].natural_32_code
						byte_count := utf_8.sequence_count (leading_byte)
						unicode := utf_8.unicode (area, leading_byte, i, byte_count)
					else
						code_1 := area [i].natural_32_code | (area [i + 1].natural_32_code |<< 8)
						byte_count := utf_16_le.sequence_count (code_1)
						unicode := utf_16_le.unicode (area, code_1, i, byte_count)
					end
					uc := unicode.to_character_32
					if unicode <= 0xFF and then l_unicodes [uc.code] = uc then
						encoded_out [j] := uc.to_character_8
					else
						c := latin_character (uc)
						if c = '%U' then
							encoded_out [j] := Substitute
							unencoded_characters.extend (uc, j + 1)
						else
							encoded_out [j] := c
						end
					end
					i := i + byte_count
					j := j + 1
				end
			end
		end

	re_encode_substring (
		other: EL_ZCODEC; str_8: READABLE_STRING_8; encoded_out: SPECIAL [CHARACTER]
		start_index, end_index, out_offset: INTEGER; unencoded_intervals: EL_ARRAYED_INTERVAL_LIST
	)
		-- re-encode single-byte `str_8' characters encoded with `other' codec
		-- Set unencodeable characters as the `Substitute' character (26) and record location in `unencoded_intervals'
		require
			valid_offset_and_count: valid_offset_and_count (end_index - start_index + 1, encoded_out, out_offset)
		local
			i, out_i, code_i, in_offset: INTEGER; c: CHARACTER; uc: CHARACTER_32
			c_8_area: SPECIAL [CHARACTER_8]; o_unicode, unicode: like unicode_table
		do
			if attached cursor_8 (str_8) as c_8 then
				in_offset := c_8.area_first_index; c_8_area := c_8.area
				if id = other.id then
					encoded_out.copy_data (c_8_area, start_index + in_offset - 1, out_offset, end_index - start_index + 1)
				else
					o_unicode := other.unicode_table; unicode := unicode_table
					from i := start_index until i > end_index loop
						c := c_8_area [i + in_offset - 1]; code_i := c.code
						out_i := i + out_offset - start_index

						if code_i <= Max_7_bit_code then -- ASCII characters are the same
							encoded_out [out_i] := c
						else
							uc := o_unicode [code_i]; code_i := uc.code

							if unicode.valid_index (code_i) and then unicode [code_i] = uc then
								encoded_out [out_i] := uc.to_character_8
							else
								c := latin_character (uc)
								if c = '%U' then
									encoded_out [out_i] := Substitute
									unencoded_intervals.extend_upper (out_i + 1)
								else
									encoded_out [out_i] := c
								end
							end
						end
						i := i + 1
					end
				end
			end
		end

	write_encoded (unicode_in: READABLE_STRING_GENERAL; writeable: EL_WRITABLE)
		local
			i, count: INTEGER; string_8: STRING
		do
			count := unicode_in.count
			across Reuseable.string_8 as reuse loop
				string_8 := reuse.sized_item (count)
				if attached string_8.area as l_area then
					encode_as_string_8 (unicode_in, l_area, 0)
					from i := 0 until i = count loop
						writeable.write_raw_character_8 (l_area [i])
						i := i + 1
					end
				end
			end
		end

	write_encoded_character (uc: CHARACTER_32; writeable: EL_WRITABLE)
		do
			writeable.write_raw_character_8 (encoded_character (uc))
		end

feature -- Basic operations

	decode (a_count: INTEGER; latin_in: SPECIAL [CHARACTER]; unicode_out: SPECIAL [CHARACTER_32]; out_offset: INTEGER)
		-- decode characters in `latin_in' to unicode outputting in `unicode_out', skipping `Substitute' characters
		-- Relative output position determined by `out_offset'
		require
			enough_latin_characters: latin_in.count > a_count
			unicode_out_big_enough: unicode_out.count >= a_count + out_offset
		local
			i, code: INTEGER; c: CHARACTER; unicode: like unicode_table
			already_latin_1: BOOLEAN
		do
			unicode := unicode_table; already_latin_1 := encoded_as_latin (1)
			from i := 0 until i = a_count loop
				c := latin_in [i]; code := c.code
				if c = Substitute then
					do_nothing -- Filled in later by call to `{EL_UNENCODED_CHARACTERS}.write'

				elseif already_latin_1 or else c <= Max_7_bit_character then
					unicode_out [i + out_offset] := c.to_character_32
				else
					unicode_out [i + out_offset] := unicode [code]
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

feature -- Text conversion

	as_unicode (encoded: READABLE_STRING_8; keeping_ref: BOOLEAN): READABLE_STRING_GENERAL
		-- returns `encoded' string as unicode assuming the encoding matches `Current' codec
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			if encoded_as_latin (1) or else cursor_8 (encoded).all_ascii then
				Result := encoded
			else
				Unicode_buffer.set_from_encoded (Current, encoded)
				Result := Unicode_buffer
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

feature -- Character conversion

	as_z_code (uc: CHARACTER_32): NATURAL
			-- Returns hybrid code of latin and unicode
			-- Single byte codes are reserved for latin encoding.
			-- Unicode characters below 0xFF are shifted into the private use range: 0xE000 .. 0xF8FF
			-- See https://en.wikipedia.org/wiki/Private_Use_Areas
		local
			c: CHARACTER; uc_code: INTEGER
		do
			uc_code := uc.code
			if uc_code <= Max_7_bit_code then
				Result := uc.natural_32_code

			elseif uc_code <= Max_8_bit_code and then unicode_table [uc_code] = uc then
				Result := uc.natural_32_code
			else
				c := latin_character (uc)
				if c = '%U' then
					Result := unicode_to_z_code (uc.natural_32_code)
				else
					Result := c.natural_32_code
				end
			end
		ensure
			reversible: z_code_as_unicode (Result) = uc.natural_32_code
		end

	encoded_character (uc: CHARACTER_32): CHARACTER
		local
			unicode: INTEGER
		do
			unicode := uc.code
			if unicode <= Max_7_bit_code then
				Result := uc.to_character_8

			elseif unicode <= Max_8_bit_code and then unicode_table [unicode] = uc then
				Result := uc.to_character_8
			else
				Result := latin_character (uc)
				if Result = '%U' then
					Result := Substitute
				end
			end
		end


	latin_character (uc: CHARACTER_32): CHARACTER
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
				Result := unicode_table [z_code.to_integer_32].natural_32_code
			end
		end

feature {NONE} -- Implementation

	change_case (
		latin_array: SPECIAL [CHARACTER]; start_index, end_index: INTEGER; change_to_upper: BOOLEAN
		unencoded_characters: EL_UNENCODED_CHARACTERS
	)
		local
			unicode_substitute: CHARACTER_32; c, new_c: CHARACTER; i: INTEGER
		do
			from i := start_index until i > end_index loop
				c := latin_array [i]
				if c /= Substitute then
					if change_to_upper then
						new_c := as_upper (c.natural_32_code).to_character_8
					else
						new_c := as_lower (c.natural_32_code).to_character_8
					end
					if c >= '~' and then new_c = c then
						unicode_substitute := unicode_case_change_substitute (c.natural_32_code)
						if unicode_substitute.natural_32_code > 0 then
							new_c := Substitute
							unencoded_characters.put (unicode_substitute, i + 1)
						end
					end
					if new_c /= c then
						latin_array [i] := new_c
					end
				end
				i := i + 1
			end
		end

feature {EL_ZSTRING} -- Deferred implementation

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

	initialize_latin_sets
		deferred
		end

	new_unicode_table: SPECIAL [CHARACTER_32]
			-- map latin to unicode
		deferred
		end

	to_lower_offset (code: NATURAL): INTEGER
		deferred
		ensure
			reversible: Result /= 0 implies as_upper ((code.to_character_8 + Result).natural_32_code) = code
		end

	to_upper_offset (code: NATURAL): INTEGER
		deferred
		ensure
			reversible: Result /= 0 implies as_lower ((code.to_character_8 + Result).natural_32_code) = code
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		deferred
		end

end