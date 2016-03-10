note
	description: "Summary description for {EL_ZLIB_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ZLIB_API

feature {NONE} -- C externals

	c_compress2 (dest, dest_len, source: POINTER; source_len: INTEGER_64; level: INTEGER): INTEGER
			-- ZEXTERN int ZEXPORT compress2 OF((Bytef *dest,   uLongf *destLen,
			--                                  const Bytef *source, uLong sourceLen,
			--                                  int level));
		external
			"C (Bytef *, uLongf *, const Bytef *, uLong, int): EIF_INTEGER | <zlib.h>"
		alias
			"compress2"
		end

	c_uncompress (dest, dest_len, source: POINTER; source_len: INTEGER_64): INTEGER
			-- ZEXTERN int ZEXPORT uncompress OF((Bytef *dest,   uLongf *destLen,
            --				                      const Bytef *source, uLong sourceLen));
		external
			"C (Bytef *, uLongf *, const Bytef *, uLong): EIF_INTEGER | <zlib.h>"
		alias
			"uncompress"
		end

	c_compress_bound (source_len: INTEGER_64): INTEGER
			-- ZEXTERN uLong ZEXPORT compressBound OF((uLong sourceLen));
		external
			"C (uLong): EIF_INTEGER | <zlib.h>"
		alias
			"compressBound"
		end

	c_size_of_ulongf: INTEGER
		external
			"C inline use <zlib.h>"
		alias
			"sizeof (uLong)"
		end

feature {NONE} -- Constants

	Z_ok: INTEGER = 0
		-- #define Z_OK            0

	Z_stream_end: INTEGER = 1
		-- #define Z_STREAM_END    1

	Z_need_dict: INTEGER = 2
		-- #define Z_NEED_DICT     2

	Z_errno: INTEGER = -1
		-- #define Z_ERRNO        (-1)

	Z_stream_error: INTEGER = -2
		-- #define Z_STREAM_ERROR (-2)

	Z_data_error: INTEGER = -3
		-- #define Z_DATA_ERROR   (-3)

	Z_mem_error: INTEGER = -4
		-- #define Z_MEM_ERROR    (-4)

	Z_buf_error: INTEGER = -5
		-- #define Z_BUF_ERROR    (-5)

	Z_version_error: INTEGER = -6
		-- #define Z_VERSION_ERROR (-6)


end
