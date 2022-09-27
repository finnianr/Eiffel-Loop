note
	description: "Digest array for MD5, SHA256 and DTA1-HMAC-SHA256 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-27 15:58:24 GMT (Tuesday 27th September 2022)"
	revision: "16"

class
	EL_DIGEST_ARRAY

inherit
	EL_BYTE_ARRAY

	EL_REFLECTION_HANDLER undefine copy, is_equal end

	EL_MODULE_BASE_64

	EL_MODULE_FILE

create
	make_final, make_from_base64, make_sink, make_from_integer_x, make_from_memory,
	make_from_plain_text

convert
	to_special: {SPECIAL [NATURAL_8]}, to_uuid: {EL_UUID}, to_data: {MANAGED_POINTER}

feature {NONE} -- Initialization

	make_from_plain_text (digest: EL_DATA_SINKABLE; file_path: FILE_PATH)
		do
			digest.reset
			if file_path.exists then
				digest.sink_string_8 (File.plain_text (file_path))
			end
			make_final (digest)
		end

	make_from_memory (digest: EL_DATA_SINKABLE; memory: MANAGED_POINTER)
		do
			digest.reset
			digest.sink_memory (memory)
			make_final (digest)
		end

	make_final (digest: EL_DATA_SINKABLE)
		do
			make (digest.byte_width)
			if attached {MD5} digest as md5 then
				md5.do_final (area, 0)

			elseif attached {SHA256} digest as sha then
				sha.do_final (area, 0)

			elseif attached {EL_HMAC_SHA_256} digest as sha then
				sha.finish
				sha.hmac.to_bytes (area, 0)
			end
		end

	make_from_base64 (base64_string: STRING)
		do
			area := Base_64.decoded_special (base64_string)
		end

	make_from_integer_x (integer: INTEGER_X)
		do
			area := integer.as_bytes
		end

	make_sink (digest: EL_DATA_SINKABLE; string: READABLE_STRING_8)
		do
			digest.reset
			digest.sink_string_8 (string)
			make_final (digest)
		end

feature -- Conversion

	to_base_64_string: STRING
		do
			Result := Base_64.encoded_special (area)
		end

	to_byte_array: EL_BYTE_ARRAY
		do
			create Result.make_from_area (area)
		end

end