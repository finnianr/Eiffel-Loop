note
	description: "Summary description for {EL_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:32:41 GMT (Wednesday 16th December 2015)"
	revision: "1"

deferred class
	EL_CODEC

inherit
	EL_MODULE_UTF

	STRING_HANDLER

feature {NONE} -- Initialization

	make
		do
			create unicode_characters.make (31)
			create latin_characters.make_filled ('%U', 1)
			unicode_table := create_unicode_table
			initialize_latin_sets
		end

feature -- Access

	id: INTEGER
		deferred
		end

	type: STRING
		deferred
		end

	name: STRING
		do
			create Result.make_from_string (type)
			Result.append_character ('-')
			Result.append_integer (id)
		end

	last_encoded_character: CHARACTER
		local
			latin_array: like latin_characters
		do
			latin_array := latin_characters
			if latin_array.count > 0 then
				Result := latin_array [0]
			end
		end

	last_encoded_foreign_character: CHARACTER_32
		local
			l_unicode_characters: like unicode_characters
		do
			l_unicode_characters := unicode_characters
			if not l_unicode_characters.is_empty then
				Result := l_unicode_characters.item (1)
			end
		end

feature -- Basic operations

	encode (
		unicode_in: READABLE_STRING_GENERAL; latin_chars_out: SPECIAL [CHARACTER]; out_offset: INTEGER
		original_characters: EL_EXTRA_UNICODE_CHARACTERS
	)
			-- encode characters as latin using Ctrl characters as place holders for foreign characters (double byte)
			-- Ctrl characters used are from 1->31 but excluding 9->13 (Tab to Carriage Return)
		require
			latin_chars_out_big_enough: latin_chars_out.count >= unicode_in.count
			valid_offset_and_count: unicode_in.count > 0 implies latin_chars_out.valid_index (unicode_in.count + out_offset - 1)
		local
			i, count, unicode: INTEGER; uc: CHARACTER_32; c: CHARACTER; l_unicodes: like unicode_table
		do
			l_unicodes := unicode_table; count := unicode_in.count
			from i := 1 until i > count loop
				uc := unicode_in [i]; unicode := uc.code
				if unicode <= 255 and then l_unicodes [unicode] = uc then
					latin_chars_out [i + out_offset - 1] := uc.to_character_8
				else
					c := latin_character (uc, unicode)
					if c.code = 0 then
						output_place_holder (uc, latin_chars_out, i + out_offset - 1, original_characters, False)
					else
						latin_chars_out [i + out_offset - 1] := c
					end
				end
				i := i + 1
			end
			original_characters.check_if_over_extended
		end

	decode (
		a_count: INTEGER; latin_chars_in: SPECIAL [CHARACTER]; unicode_chars_out: SPECIAL [CHARACTER_32]
		original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
	)
			-- Replace Ctrl characters used as place holders for foreign characters with original unicode characters.
			-- If 'a_decode' is true encode output as unicode
		require
			enough_latin_chars_in: latin_chars_in.count > a_count
			unicode_chars_out_big_enough: unicode_chars_out.count > a_count
		local
			i, code: INTEGER; c, place_holder_upper: CHARACTER
			original_characters: SPECIAL [CHARACTER_32]; l_unicodes: like unicode_table
		do
			l_unicodes := unicode_table
			original_characters := original_characters_string.area
			place_holder_upper := original_characters_string.upper_place_holder
			-- add normal characters
			from i := 0 until i = a_count loop
				c := latin_chars_in [i]; code := c.code
				if c <= place_holder_upper then
					if c > '%U' and c < '%T' then
						unicode_chars_out [i] := original_characters [code - 1]
					elseif c > '%R' then
						unicode_chars_out [i] := original_characters [code - 6]
					else
						unicode_chars_out [i] := l_unicodes [code]
					end
				else
					unicode_chars_out [i] := l_unicodes [code]
				end
				i := i + 1
			end
		end

	lower_case (
		characters: SPECIAL [CHARACTER]; start_index, end_index: INTEGER
		original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
	)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			change_case (characters, start_index, end_index, False, original_characters_string)
		end

	upper_case (
		characters: SPECIAL [CHARACTER]; start_index, end_index: INTEGER
		original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
	)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			change_case (characters, start_index, end_index, True, original_characters_string)
		end

feature -- Character query

	is_alpha_numeric (code: NATURAL): BOOLEAN
		do
			Result := is_numeric (code) or else is_alpha (code)
		end

	is_upper (code: NATURAL): BOOLEAN
		deferred
		end

	is_lower (code: NATURAL): BOOLEAN
		deferred
		end

	is_alpha (code: NATURAL): BOOLEAN
		deferred
		end

	is_numeric (code: NATURAL): BOOLEAN
		deferred
		end

feature -- Conversion

	as_unicode (c: CHARACTER): CHARACTER_32
			-- lookup for character which there is not a place holder
		do
			Result := unicode_table [c.code]
		end

	as_latin (uc: CHARACTER_32): CHARACTER
			--
		local
			unicode: INTEGER
		do
			unicode := uc.code
			if unicode <= 255 and then unicode_table [unicode] = uc then
				Result := uc.to_character_8
			else
				Result := latin_character (uc, unicode)
			end
		end

	as_upper (code: NATURAL): NATURAL
		deferred
		ensure then
			reversible: code /= Result implies code = as_lower (Result)
		end

	as_lower (code: NATURAL): NATURAL
		deferred
		ensure then
			reversible: code /= Result implies code = as_upper (Result)
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		deferred
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in current set
		deferred
		ensure
			valid_latin: Result /= '%U' implies unicode_table [Result.code] = uc
		end

feature {EL_ASTRING} -- Element change

	set_encoded_character (uc: CHARACTER_32)
		local
			l_unicode_characters: like unicode_characters
			l_latin_characters: like latin_characters
			c: CHARACTER; unicode: INTEGER
		do
			l_unicode_characters := unicode_characters; l_unicode_characters.wipe_out
			l_latin_characters := latin_characters
			unicode := uc.code
			if unicode <= 255 and then unicode_table [unicode] = uc then
				l_latin_characters [0] := uc.to_character_8
			else
				c := latin_character (uc, unicode)
				if c.code = 0 then
					output_place_holder (uc, l_latin_characters, 0, l_unicode_characters, True)
				else
					l_latin_characters [0] := c
				end
			end
		end

feature {EL_ASTRING} -- Basic operations

	updated_foreign_characters (
		latin_array: SPECIAL [CHARACTER]; count: INTEGER; original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
	): SPECIAL [CHARACTER_32]
		local
			l_unicode_characters: like unicode_characters
		do
			l_unicode_characters := unicode_characters
			l_unicode_characters.wipe_out

			update_foreign_characters (latin_array, count, 0, original_characters_string, l_unicode_characters, True)

			if l_unicode_characters.has_characters then
				l_unicode_characters.check_if_over_extended
				Result := l_unicode_characters.area.resized_area (l_unicode_characters.count)
			else
				Result := l_unicode_characters.Default_area
			end
		end

	update_foreign_characters (
		latin_array: SPECIAL [CHARACTER]; count, offset: INTEGER
		previous_original_characters_string, original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
		is_original_characters_reusable: BOOLEAN
	)
		require
			valid_offset_and_count: count > 0 implies latin_array.valid_index (count + offset - 1)
		local
			i, unicode, offset_count: INTEGER;
			c, place_holder_upper: CHARACTER
			previous_original_characters: SPECIAL [CHARACTER_32]
			uc: CHARACTER_32
		do
			place_holder_upper := previous_original_characters_string.upper_place_holder
			previous_original_characters := previous_original_characters_string.area
			offset_count := count + offset

			from i := offset until i = offset_count loop
				c := latin_array [i]
				if c <= place_holder_upper then
					unicode := c.code
					if c > '%U' and c < '%T' then
						uc := previous_original_characters [unicode - 1]
						output_place_holder (uc, latin_array, i, original_characters_string, is_original_characters_reusable)
					elseif c > '%R' then
						uc := previous_original_characters [unicode - 6]
						output_place_holder (uc, latin_array, i, original_characters_string, is_original_characters_reusable)
					end
				end
				i := i + 1
			end
		end

feature {EL_ASTRING} -- Implementation

	change_case (
		latin_array: SPECIAL [CHARACTER]; start_index, end_index: INTEGER; change_to_upper: BOOLEAN
		original_characters_string: EL_EXTRA_UNICODE_CHARACTERS
	)
		local
			unicode_substitute: CHARACTER_32; c, place_holder_upper: CHARACTER
			is_place_holder, case_change_exception_inserted: BOOLEAN
			i: INTEGER
				-- Set to true if the case changed to character not present in Latin set
		do
			place_holder_upper := original_characters_string.count.to_character_8 -- area count may not be right

			from i := start_index until i > end_index loop
				c := latin_array [i]
				is_place_holder := c <= place_holder_upper and then ((c > '%U' and c < '%T') or c > '%R')
				if not is_place_holder then
					unicode_substitute := unicode_case_change_substitute (c.natural_32_code)
					if unicode_substitute.code = 0 then
						if change_to_upper then
							latin_array.put (as_upper (c.natural_32_code).to_character_8, i)
						else
							latin_array.put (as_lower (c.natural_32_code).to_character_8, i)
						end
					else
						output_place_holder (unicode_substitute, latin_array, i, original_characters_string, False)
						case_change_exception_inserted := True
					end
				end
				i := i + 1
			end
			if case_change_exception_inserted then -- we need to normalize the string place holders because it's foreign
				original_characters_string.set_from_area (
					updated_foreign_characters (latin_array, end_index + 1, original_characters_string)
				)
			end
		end

	output_place_holder (
		uc: CHARACTER_32; latin_chars_out: SPECIAL [CHARACTER]; i: INTEGER
		original_characters: EL_EXTRA_UNICODE_CHARACTERS; is_original_characters_reusable: BOOLEAN
	)
		local
			place_holder: CHARACTER
		do
			place_holder := original_characters.place_holder (uc)
			if place_holder.code = 0 then
				if is_original_characters_reusable then
					original_characters.area.extend (uc)
				else
					-- This causes a new array allocation if array is empty
					original_characters.extend (uc)
				end
				place_holder := original_characters.upper_place_holder
			end
			latin_chars_out [i] := place_holder
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

	latin_set_from_array (array: ARRAY [INTEGER]): SPECIAL [CHARACTER]
		do
			create Result.make_empty (array.count)
			across array as c loop
				Result.extend (c.item.to_character_8)
			end
		end

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- map latin to unicode
		deferred
		end

	initialize_latin_sets
		deferred
		end

feature {NONE} -- Internal attributes

	latin_characters: SPECIAL [CHARACTER]

	unicode_characters: EL_EXTRA_UNICODE_CHARACTERS
		-- foreign character buffer

	unicode_table: like create_unicode_table
		-- map latin to unicode

end