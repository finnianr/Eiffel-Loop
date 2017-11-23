note
	description: "Summary description for {EL_DIGEST_ARRAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DIGEST_ARRAY

inherit
	ARRAY [NATURAL_8]
		export
			{NONE} all
			{ANY} area, to_special
		end

create
	make, make_md5_128, make_sha_256, make_hmac_sha_256, make_from_integer_x

convert
	to_special: {SPECIAL [NATURAL_8]}

feature {NONE} -- Initialization

	make_from_integer_x (integer: INTEGER_X)
		do
			area := integer.as_bytes
			lower := 1
			upper := area.count
		end

	make_md5_128 (string: STRING)
		local
			md5: EL_MD5_128
		do
			md5 := Once_md5; md5.reset
			make (1, 16)
			md5.sink_string (string)
			md5.do_final (area, 0)
		end

	make_sha_256 (string: STRING)
		local
			sha256: EL_SHA_256
		do
			sha256 := Once_sha256; sha256.reset
			make (1, 32)
			sha256.sink_string (string)
			sha256.do_final (area, 0)
		end

	make_hmac_sha_256 (string, secret_key: STRING)
		local
			hmac: EL_HMAC_SHA_256; table: like Hmac_sha_256_table
		do
			table := Hmac_sha_256_table
			table.search (secret_key)
			if table.found then
				hmac := table.found_item
			else
				create hmac.make_ascii_key (secret_key)
				table.extend (hmac, secret_key)
			end
			hmac.reset
			make (1, 32)
			hmac.sink_string (string)
			hmac.finish
			hmac.hmac.to_bytes (area, 0)
		end

feature -- Conversion

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

	Once_md5: EL_MD5_128
		once
			create Result.make
		end

	Once_sha256: EL_SHA_256
		once
			create Result.make
		end

	Hmac_sha_256_table: HASH_TABLE [EL_HMAC_SHA_256, STRING]
		once
			create Result.make_equal (3)
		end
end
