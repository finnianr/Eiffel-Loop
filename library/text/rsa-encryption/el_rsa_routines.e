note
	description: "Rsa routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-26 11:29:27 GMT (Monday 26th July 2021)"
	revision: "16"

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