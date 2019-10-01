note
	description: "Digest array for MD5, SHA256 and DTA1-HMAC-SHA256 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 19:35:41 GMT (Tuesday   1st   October   2019)"
	revision: "8"

class
	EL_DIGEST_ARRAY

inherit
	ARRAY [NATURAL_8]
		export
			{NONE} all
			{ANY} area, to_special, count
		end

	EL_REFLECTION_HANDLER undefine copy, is_equal end

	EL_MODULE_BASE_64

create
	make_final, make_reflective, make_from_base64, make_sink, make_from_integer_x

convert
	to_special: {SPECIAL [NATURAL_8]}, to_uuid: {EL_UUID}, to_data: {MANAGED_POINTER}

feature {NONE} -- Initialization

	make_final (digest: EL_DATA_SINKABLE)
		do
			make_filled (0, 1, digest.byte_width)
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
		local
			plain: STRING
		do
			plain := Base_64.decoded (base64_string)
			make_filled (0, 1, plain.count)
			area.base_address.memory_copy (plain.area.base_address, plain.count)
		end

	make_from_integer_x (integer: INTEGER_X)
		do
			area := integer.as_bytes
			lower := 1
			upper := area.count
		end

	make_reflective (digest: EL_DATA_SINKABLE; object: EL_REFLECTIVE; except_field_names: STRING)
		do
			digest.reset
			object.meta_data.sink_except (object, digest, except_field_names)
			make_final (digest)
		end

	make_sink (digest: EL_DATA_SINKABLE; string: STRING)
		do
			digest.reset
			digest.sink_string (string)
			make_final (digest)
		end

feature -- Conversion

	to_base_64_string: STRING
		do
			Result := Base_64.encoded_special (area)
		end

	to_hex_string: STRING
		local
			i, offset, val: INTEGER
			l_area: like area
		do
			create Result.make_filled (' ', 2 * count)
			l_area := area
			from i := 0 until i = count loop
				offset := i* 2
				val := l_area [i]
				Result [offset + 1] := (val |>> 4).to_hex_character
				Result [offset + 2] := (val & 0xF).to_hex_character
				i := i + 1
			end
		end

	to_data: MANAGED_POINTER
		do
			create Result.make_from_array (Current)
		end

	to_uuid: EL_UUID
		local
			data: MANAGED_POINTER
		do
			if count = 16 then
				create Result.make_from_array (Current)
			else
				data := to_data
				create Result.make (
					data.read_natural_32 (0),
					data.read_natural_16 (4), data.read_natural_16 (6), data.read_natural_16 (8),
					data.read_natural_64 (10)
				)
			end
		end

end
