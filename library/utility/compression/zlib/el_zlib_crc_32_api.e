note
	description: "Zlib C API for calculating CRC-32/ISO-HDLC checksums"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	date: "2026-06-29 6:31:14 GMT (Monday 29th June 2026)"
	revision: "1"

class
	EL_ZLIB_CRC_32_API

inherit
	EL_C_API

feature {NONE} -- C Externals

	frozen c_crc_32 (value: NATURAL_32; byte_array: POINTER; a_count: INTEGER): NATURAL_32
		-- CRC-32/ISO-HDLC of `byte_array`, continuing from running checksum `a_crc`.
		-- Pass `crc32_seed` as `a_crc` for the first call in a sequence.
		external
			"C inline use <zlib.h>"
		alias
			"[
				return (EIF_NATURAL_32) crc32 (
					(unsigned long) $value, (const unsigned char *) $byte_array, (unsigned int) $a_count
				);
			]"
		end

	frozen c_crc_32_seed: NATURAL_32
			-- Initial CRC-32 value to seed an accumulation sequence.
		external
			"C inline use <zlib.h>"
		alias
			"return (EIF_NATURAL_32) crc32(0L, Z_NULL, 0);"
		end

end
