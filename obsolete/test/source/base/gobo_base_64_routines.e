note
	description: "Base 64 routines based on GOBO codecs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	GOBO_BASE_64_ROUTINES

feature -- Conversion

	encoded (a_string: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := encoded_special (s.to_code_array (a_string))
		end

	encoded_special (array: SPECIAL [NATURAL_8]): STRING
			--
		local
			out_stream: KL_STRING_OUTPUT_STREAM
			l_encoder: UT_BASE64_ENCODING_OUTPUT_STREAM
			data_string: STRING
		do
			create data_string.make_filled ('%/0/', array.count)
			data_string.area.base_address.memory_copy (array.base_address, array.count)

			create out_stream.make_empty
			create l_encoder.make (out_stream, False, False)
			l_encoder.put_string (data_string)
			l_encoder.close
			Result := out_stream.string
--		ensure
--			reversable: array ~ decoded_array (Result).area
		end

	joined (base64_lines: STRING): STRING
			-- base64 string with all newlines removed.
			-- Useful for manifest constants of type "[
			-- ]"
		do
			Result := base64_lines.twin
			Result.prune_all ('%N')
		end

	decoded (base64_string: STRING): STRING
			--
		local
			l_decoder: UT_BASE64_DECODING_INPUT_STREAM
			input_stream: KL_STRING_INPUT_STREAM
		do
			if base64_string.is_empty then
				create Result.make_empty
			else
				create input_stream.make (base64_string)
				create l_decoder.make (input_stream)
				l_decoder.read_string (base64_string.count)
				Result := l_decoder.last_string
			end
		end

	decoded_special (base64_string: STRING): SPECIAL [NATURAL_8]
		do
			Result := decoded_array (base64_string).area
		end

	decoded_array (base64_string: STRING): ARRAY [NATURAL_8]
			--
		local
			plain: STRING
		do
			plain := decoded (base64_string)
			create Result.make_filled (0, 1, plain.count)
			Result.area.base_address.memory_copy (plain.area.base_address, plain.count)
		end

end