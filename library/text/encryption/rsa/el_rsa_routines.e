note
	description: "Summary description for {EL_RSA_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-22 13:16:31 GMT (Wednesday 22nd April 2015)"
	revision: "4"

class
	EL_RSA_ROUTINES

inherit
	EL_BASE_64_ROUTINES

feature -- Conversion

	integer_x_from_base64_lines (base64_lines: STRING): INTEGER_X
			-- Use for code constants split across lines with "[
			-- ]"
		local
			base64: STRING
		do
			base64 := base64_lines.twin
			base64.prune_all ('%N')
			Result := integer_x_from_base64 (base64)
		end

	integer_x_from_base64 (base64: STRING): INTEGER_X
			--
		do
			Result := integer_x_from_array (decoded_array (base64))
		end

	integer_x_from_array (byte_array: SPECIAL [NATURAL_8]): INTEGER_X
			--
		do
			create Result.make_from_bytes (byte_array, byte_array.lower, byte_array.upper)
		end

	integer_x_from_hex_byte_sequence (hex_byte_sequence: STRING): INTEGER_X
			-- Convert string of form:
			-- 		00:d9:61:6e:a7:03:21:2f:70:d2:22:38:d7:99:d4:
			-- 		bc:6d:55:7f:cc:97:9a:5d:8b:a3:d3:84:d3

			-- this is a special case that indicates a form of encoding, known as "indefinite-length encoding," is being used,
			-- in which case the end of this ASN.1 value's data is marked by two consecutive zero-value octets.
		local
			hex_string, first_byte: STRING
			i, colon_pos, first_character_pos, byte_count: INTEGER; c: CHARACTER
		do
			colon_pos := hex_byte_sequence.index_of (':', 1)
			first_byte := hex_byte_sequence.substring (colon_pos - 2, colon_pos - 1)
			byte_count := hex_byte_sequence.occurrences (':')
			if first_byte ~ "00" then
				first_character_pos := colon_pos + 1
			else
				first_character_pos := colon_pos - 2
				byte_count := byte_count + 1
			end
			create hex_string.make (byte_count * 2)
			from i := first_character_pos until i > hex_byte_sequence.count loop
				c := hex_byte_sequence [i]
				if c.is_alpha_numeric then
					hex_string.append_character (c)
				end
				i := i + 1
			end
			create Result.make_from_hex_string (hex_string)
		end

	private_key (pkcs1_private_key_file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER): EL_RSA_PRIVATE_KEY
		local
			reader: EL_PKCS1_RSA_PRIVATE_KEY_READER
		do
			create reader.make_from_file (pkcs1_private_key_file_path, encrypter)
			create Result.make_from_pkcs1 (reader.values)
		end

end
