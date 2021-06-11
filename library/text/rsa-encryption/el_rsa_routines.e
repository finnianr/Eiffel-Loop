note
	description: "Rsa routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-09 11:10:54 GMT (Wednesday 9th June 2021)"
	revision: "14"

class
	EL_RSA_ROUTINES

inherit
	ANY

	EL_MODULE_BASE_64

	EL_MODULE_HEXADECIMAL

	EL_MODULE_BUFFER_8

feature -- Conversion

	integer_x_from_base_64_lines (base64_lines: STRING): INTEGER_X
			-- Use for code constants split across lines with "[
			-- ]"
		local
			base_64_string: STRING
		do
			base_64_string := Buffer_8.copied (base64_lines)
			base_64_string.prune_all ('%N')
			Result := integer_x_from_base_64 (base_64_string)
		end

	integer_x_from_base_64 (base_64_string: STRING): INTEGER_X
			--
		do
			Result := integer_x_from_array (Base_64.decoded_special (base_64_string))
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
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			create parts.make (sequence, once ":")
			hex_string := buffer.empty
			from parts.start until parts.after loop
				if not (parts.index = 1 and then parts.same_item_as (Double_zero)) then
					hex_string.append (parts.item (False))
				end
				parts.forth
			end
			create Result.make_from_hex_string (hex_string)
		end

	pkcs1_map_list (lines: LINEAR [ZSTRING]): EL_ARRAYED_MAP_LIST [STRING, STRING]
		-- convert lines in PKCS1 format to name value pairs. As for example:

		-- 	publicExponent: 65537 (0x10001)
		-- 	privateExponent:
		--  		61:32:bd:31:a1:ca:1a:06:9d:20:31:44:b3:08:4d:
		--   		01:b1:6a:c7:98:72:91:6a:fb:18:08:b2:aa:b7:b8

		-- BECOMES

		-- 	"publicExponent" : "10001"
		-- 	"privateExponent" : "61:32:bd:31:a1:ca:1a:06:9d:20:31:44:b3:08:4d:01:b1:6a:c7:98:72:91:6a:fb:18:08:b2:aa:b7:b8"

		local
			line, value: ZSTRING; pos_colon, byte_count: INTEGER
			name: STRING
		do
			create Result.make (8)
			from lines.start until lines.after loop
				line := lines.item
				if line.count >= 6 and then line.leading_occurrences (' ') = 4
					and then Hexadecimal.is_valid_sequence (line, 5, 6)
				then
					line.substring_end (5).append_to_string_8 (Result.last_value)

				else
					pos_colon := line.index_of (':', 1)
					if pos_colon > 0 then
						name := line.substring (1, pos_colon - 1)
						if line.has ('(') then
							value := line.substring_between (Bracket_left, Bracket_right, pos_colon)
							if value.ends_with_general ("bit") then -- Private-Key: (2048 bit)
								value.remove_tail (4)
								byte_count := value.to_integer // 8
							else
								value.remove_head (2) -- 0x10001
								Result.extend (name, value)
							end
						else
							Result.extend (name, create {STRING}.make (byte_count * 3))
						end
					end
				end
				lines.forth
			end
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