note
	description: "Base 64 routines accessible via ${EL_MODULE_BASE_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 7:52:51 GMT (Tuesday 6th May 2025)"
	revision: "20"

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
			str: EL_STRING_8
		do
			str := decoded_special (base64_string)
			Result := str.as_shared
		end

	decoded_array (base64_string: STRING): ARRAY [NATURAL_8]
		do
			create Result.make_from_special (decoded_special (base64_string))
		end

	decoded_special (base_64_string: STRING): SPECIAL [NATURAL_8]
		do
			Result := decoder.data (base_64_string)
		end

	encoded (a_string: STRING; line_breaks: BOOLEAN): STRING
		do
			encoder.enable_line_breaks (line_breaks)
			encoder.put_string (a_string)
			Result := encoder.output (True)
			encoder.enable_line_breaks (False)
		end

	encoded_array (array: ARRAY [NATURAL_8]): STRING
		do
			encoder.put_natural_8_array (array)
			Result := encoder.output (True)
		end

	encoded_memory (bytes: MANAGED_POINTER; nb: INTEGER; line_breaks: BOOLEAN): STRING
		do
			encoder.enable_line_breaks (line_breaks)
			encoder.put_memory (bytes, nb)
			Result := encoder.output (True)
			encoder.enable_line_breaks (False)
		end

	encoded_special (array: SPECIAL [NATURAL_8]; line_breaks: BOOLEAN): STRING
		do
			encoder.enable_line_breaks (line_breaks)
			encoder.put_natural_8_array (array)
			Result := encoder.output (True)
			encoder.enable_line_breaks (False)
		end

	encode_to_writable (bytes: MANAGED_POINTER; nb: INTEGER; writable: EL_WRITABLE; line_breaks: BOOLEAN)
		require
			valid_size: nb <= bytes.count
		do
			encoder.enable_line_breaks (line_breaks)
			encoder.put_memory (bytes, nb)
			writable.write_encoded_string_8 (encoder.output (False))
			encoder.enable_line_breaks (False)
		end

feature {NONE} -- Internal attributes

	decoder: EL_BASE_64_DECODER

	encoder: EL_BASE_64_ENCODER

end