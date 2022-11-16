note
	description: "Base 64 routines accessible via [$source EL_MODULE_BASE_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_BASE_64_CODEC

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

	decoded_special (base_64_string: STRING): SPECIAL [NATURAL_8]
		local
			str: STRING; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if base_64_string.has ('%N') then
				str := buffer.copied (base_64_string)
				str.prune_all ('%N')
			else
				str := base_64_string
			end
			Result := decoder.data (str)
		end

	encoded (a_string: STRING): STRING
		do
			encoder.put_string (a_string)
			Result := encoder.output (True)
		end

	encoded_array (array: ARRAY [NATURAL_8]): STRING
		do
			encoder.put_natural_8_array (array)
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
			Result.prune_all ('%N')
		end

feature {NONE} -- Internal attributes

	decoder: EL_BASE_64_DECODER

	encoder: EL_BASE_64_ENCODER

end