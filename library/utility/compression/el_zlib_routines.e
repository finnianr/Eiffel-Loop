note
	description: "Zlib routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 10:20:01 GMT (Friday 14th August 2020)"
	revision: "6"

class
	EL_ZLIB_ROUTINES

inherit
	EL_ZLIB_API

	STRING_HANDLER

	EL_MODULE_EXCEPTION

feature -- Conversion

	compress (source: MANAGED_POINTER; expected_compression_ratio: DOUBLE; level: INTEGER): SPECIAL [NATURAL_8]
		require
			valid_level: (-1 |..| 9).has (level)
		local
			status: INTEGER
			compressed_count, upper_bound: INTEGER_64
			upper_compression_ratio, compression_ratio: DOUBLE
			is_done: BOOLEAN
		do
			upper_bound := c_compress_bound (source.count)
			upper_compression_ratio := upper_bound / source.count
			from
				compression_ratio := expected_compression_ratio
			until
				is_done or compression_ratio > upper_compression_ratio + 0.1
			loop
				compressed_count := upper_bound.min ((source.count * compression_ratio).rounded)

				create Result.make_filled (0, compressed_count.to_integer)
				status := c_compress2 (Result.base_address, $compressed_count, source.item, source.count, level)
				inspect status
					when Z_ok then
						Result.keep_head (compressed_count.to_integer)
						is_done := True

					when Z_buf_error then
						compression_ratio := compression_ratio + 0.1
--						log.put_real_field ("compression_ratio", compression_ratio)
--						log.put_new_line

				else
					on_error (status)
					is_done := True
				end
			end
		ensure
			compressed: Result.count > 0
		end

	uncompress (source: MANAGED_POINTER; orginal_count: INTEGER): SPECIAL [NATURAL_8]
			--
		local
			status: INTEGER; uncompressed_count: INTEGER_64
		do
			uncompressed_count := orginal_count
			create Result.make_filled (0, uncompressed_count.to_integer)
			status := c_uncompress (Result.base_address, $uncompressed_count, source.item, source.count)
			inspect status
				when Z_ok then
					Result.keep_head (uncompressed_count.to_integer)
					last_compression_ratio := (source.count / uncompressed_count.to_integer).truncated_to_real
			else
				on_error (status)
			end
		ensure
			same_count_as_original: orginal_count = Result.count
		end

feature -- Access

	last_compression_ratio: REAL

feature {NONE} -- Initialization

	on_error (error: INTEGER)
		local
			message: STRING
		do
			inspect error
				when Z_stream_end then
					message := "stream end"

				when Z_need_dict then
					message := "need dict"

				when Z_stream_error then
					message := "level parameter is invalid"

				when Z_data_error then
					message := "input data corrupted or incomplete"

				when Z_mem_error then
					message := "not enough memory"

				when Z_buf_error then
					message := "not enough room in the output buffer"

				when Z_version_error then
					message := "library version does not match header"
			else
				message := ""
			end
			Exception.raise_developer ("Zlib: " + message, [])
		end
end
