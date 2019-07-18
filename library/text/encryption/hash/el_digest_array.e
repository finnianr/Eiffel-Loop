note
	description: "Digest array for MD5, SHA256 and DTA1-HMAC-SHA256 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:09:38 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_DIGEST_ARRAY

inherit
	ARRAY [NATURAL_8]
		rename
			make as make_array
		export
			{NONE} all
			{ANY} area, to_special, count
		end

	EL_MODULE_BASE_64

create
	make, make_from_base64, make_md5_128, make_sha_256, make_hmac_sha_256, make_from_integer_x,
	make_final_sha_256, make_final_md5_128

convert
	to_special: {SPECIAL [NATURAL_8]}

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_filled (0, 1, n)
		end

	make_final_md5_128 (md5: EL_MD5_128)
		do
			make (16)
			md5.do_final (area, 0)
		end

	make_final_sha_256 (sha: EL_SHA_256)
		do
			make (32)
			sha.do_final (area, 0)
		end

	make_from_base64 (base64_string: STRING)
		local
			plain: STRING
		do
			plain := Base_64.decoded (base64_string)
			make (plain.count)
			area.base_address.memory_copy (plain.area.base_address, plain.count)
		end

	make_from_integer_x (integer: INTEGER_X)
		do
			area := integer.as_bytes
			lower := 1
			upper := area.count
		end

	make_hmac_sha_256 (string, secret_key: STRING)
		local
			hmac: EL_HMAC_SHA_256; table: like Hmac_sha_256_table
		do
			make (32)

			table := Hmac_sha_256_table
			if table.has_key (secret_key) then
				hmac := table.found_item
			else
				create hmac.make_ascii_key (secret_key)
				table.extend (hmac, secret_key)
			end
			hmac.reset
			hmac.sink_string (string)
			hmac.finish
			hmac.hmac.to_bytes (area, 0)
		end

	make_md5_128 (string: STRING)
		local
			md5: EL_MD5_128
		do
			md5 := Once_md5; md5.reset
			md5.sink_string (string)
			make_final_md5_128 (md5)
		end

	make_sha_256 (string: STRING)
		local
			sha: EL_SHA_256
		do
			sha := Once_sha_256; sha.reset
			sha.sink_string (string)
			make_final_sha_256 (sha)
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

feature {NONE} -- Constants

	Hmac_sha_256_table: HASH_TABLE [EL_HMAC_SHA_256, STRING]
		once
			create Result.make_equal (3)
		end

	Once_md5: EL_MD5_128
		once
			create Result.make
		end

	Once_sha_256: EL_SHA_256
		once
			create Result.make
		end

end
