note
	description: "Rsa routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-23 18:46:29 GMT (Friday 23rd July 2021)"
	revision: "15"

class
	EL_RSA_ROUTINES

inherit
	ANY

	EL_MODULE_BASE_64

	EL_MODULE_HEXADECIMAL

feature -- Conversion

	integer_x_from_base_64 (base_64_string: STRING): INTEGER_X
		--
		local
			str: STRING; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if base_64_string.has ('%N') then
				str := buffer.copied (base_64_string)
				str.prune_all ('%N')
			else
				str := base_64_string
			end
			Result := integer_x_from_array (Base_64.decoded_special (str))
		end

	integer_x_from_array (byte_array: SPECIAL [NATURAL_8]): INTEGER_X
			--
		do
			create Result.make_from_bytes (byte_array, byte_array.lower, byte_array.upper)
		end

	integer_x_from_hex_sequence (sequence: STRING): INTEGER_X
			-- Convert `sequence' of form:

			-- 	00:d9:61:6e:a7:03:21:2f:70:d2:22:38:d7:99:d4:..

			-- to type `INTEGER_X'
		local
			parts: EL_SPLIT_STRING_LIST [STRING]; hex_string: STRING
			buffer: EL_STRING_8_BUFFER_ROUTINES; s: EL_STRING_8_ROUTINES
		do
			create parts.make (sequence, s.character_string (':'))
			hex_string := buffer.empty
			from parts.start until parts.after loop
				if not (parts.index = 1 and then parts.same_item_as (Double_zero)) then
					hex_string.append (parts.item (False))
				end
				parts.forth
			end
			create Result.make_from_hex_string (hex_string)
		end

feature {NONE} -- Constants

	Double_zero: STRING = "00"

	Bracket_left: ZSTRING
		once
			Result := "("
		end

	Bracket_right: ZSTRING
		once
			Result := ")"
		end

end