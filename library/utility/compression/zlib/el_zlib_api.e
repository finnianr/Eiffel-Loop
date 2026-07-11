note
	description: "[
		[https://www.zlib.net/manual.html Zlib library] API
	]"
	notes: "[
		7 Sep 2024
		
		Confirmed that C argument type changes has not broken anything.
		For example: `TYPED_POINTER [INTEGER_64] -> TYPED_POINTER [NATURAL_64]'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 15:11:33 GMT (Sunday 8th September 2024)"
	revision: "11"

class
	EL_ZLIB_API

inherit
	EL_C_API

feature {NONE} -- C externals

	c_compress2 (
		destination: POINTER; compressed_count: TYPED_POINTER [NATURAL_64]
		source: POINTER; source_count: NATURAL_64; level: INTEGER

	): INTEGER
		-- ZEXTERN int ZEXPORT compress2 OF((Bytef *destination, uLongf *destLen,
		--             	                     const Bytef *source, uLong sourceLen, int level));
		external
			"C (Bytef *, uLongf *, const Bytef *, uLong, int): EIF_INTEGER | <zlib.h>"
		alias
			"compress2"
		end

	c_uncompress (
		destination: POINTER; decompressed_count: TYPED_POINTER [NATURAL_64]
		source: POINTER; source_count: NATURAL_64
	): INTEGER
		-- ZEXTERN int ZEXPORT uncompress OF((Bytef *destination, uLongf *destLen,
		--				               			       const Bytef *source, uLong sourceLen));
		external
			"C (Bytef *, uLongf *, const Bytef *, uLong): EIF_INTEGER | <zlib.h>"
		alias
			"uncompress"
		end

	c_compress_bound (source_count: NATURAL_64): NATURAL_64
			-- ZEXTERN uLong ZEXPORT compressBound OF((uLong sourceLen));
		external
			"C (uLong): EIF_INTEGER | <zlib.h>"
		alias
			"compressBound"
		end

	c_size_of_ulong: NATURAL_64
		external
			"C inline use <zlib.h>"
		alias
			"sizeof (uLong)"
		end

feature {NONE} -- Constants

	Z_ok: INTEGER = 0
		-- #define Z_OK 0

	Z_stream_end: INTEGER = 1
		-- #define Z_STREAM_END 1

	Z_errno: INTEGER = -1
		-- #define Z_ERRNO (-1)

	Z_stream_error: INTEGER = -2
		-- #define Z_STREAM_ERROR (-2)

	Z_data_error: INTEGER = -3
		-- #define Z_DATA_ERROR (-3)

	Z_mem_error: INTEGER = -4
		-- #define Z_MEM_ERROR (-4)

	Z_buf_error: INTEGER = -5
		-- #define Z_BUF_ERROR (-5)

	Z_version_error: INTEGER = -6
		-- #define Z_VERSION_ERROR (-6)

end