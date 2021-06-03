note
	description: "Base 64 routines accessible via [$source EL_MODULE_BASE_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-03 15:57:34 GMT (Thursday 3rd June 2021)"
	revision: "10"

class
	EL_BASE_64_ROUTINES

inherit
	ANY EL_MODULE_BUFFER_8

create
	make

feature {NONE} -- Initialization

	make
		do
			create encoder.make
			create decoder.make
		end

feature -- Conversion

	decoded (base64_string: STRING): STRING
		local
			data: like decoded_special
		do
			data := decoded_special (base64_string)
			create Result.make_filled ('%U', data.count)
			Result.area.base_address.memory_copy (data.base_address, data.count)
		end

	decoded_array (base64_string: STRING): ARRAY [NATURAL_8]
		do
			create Result.make_from_special (decoded_special (base64_string))
		end

	decoded_special (base64_string: STRING): SPECIAL [NATURAL_8]
		local
			i, pad_count: INTEGER; padded: STRING
		do
			if base64_string.count \\ 4 > 0 then
				padded := Buffer_8.copied (base64_string)
				pad_count := 4 - base64_string.count \\ 4
				from i := 1 until i > pad_count loop
					padded.append_character ('=')
					i := i + 1
				end
				Result := decoder.data (padded)
			else
				Result := decoder.data (base64_string)
			end
		end

	encoded (a_string: STRING): STRING
		do
			encoder.put_string (a_string)
			Result := encoder.output (True)
		end

	encoded_special (array: SPECIAL [NATURAL_8]): STRING
		do
			encoder.put_natural_8_array (array)
			Result := encoder.output (True)
		end

	joined (base64_lines: STRING): STRING
			-- base64 string with all newlines removed.
			-- Useful for manifest constants of type "[
			-- ]"
		do
			Result := base64_lines.twin
			base64_lines.prune_all ('%N')
		end

feature {NONE} -- Internal attributes

	decoder: EL_BASE_64_DECODER
	encoder: EL_BASE_64_ENCODER

end