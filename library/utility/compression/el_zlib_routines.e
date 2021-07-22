note
	description: "Zlib routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 7:50:58 GMT (Thursday 22nd July 2021)"
	revision: "8"

class
	EL_ZLIB_ROUTINES

inherit
	EL_ZLIB_API

	EL_MODULE_EXCEPTION

feature -- Conversion

	compressed (source: MANAGED_POINTER; level: INTEGER; expected_compression_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: (-1 |..| 9).has (level)
		do
			Result := new_compressed (source.item, source.count, level, expected_compression_ratio)
		end

	compressed_string (source: STRING; level: INTEGER; expected_compression_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: (-1 |..| 9).has (level)
		do
			Result := new_compressed (source.area.base_address, source.count, level, expected_compression_ratio)
		end

	decompressed (source: MANAGED_POINTER; orginal_count: INTEGER): SPECIAL [NATURAL_8]
			--
		do
			Result := new_decompressed (source.item, source.count, orginal_count)
		end

	decompressed_bytes (source: SPECIAL [NATURAL_8]; orginal_count: INTEGER): SPECIAL [NATURAL_8]
			--
		do
			Result := new_decompressed (source.base_address, source.count, orginal_count)
		end

feature -- Access

	error_message: STRING
		do
			inspect error_status
				when Z_stream_end then
					Result := "stream end"

				when Z_need_dict then
					Result := "need dict"

				when Z_stream_error then
					Result := "level parameter is invalid"

				when Z_data_error then
					Result := "input data corrupted or incomplete"

				when Z_mem_error then
					Result := "not enough memory"

				when Z_buf_error then
					Result := "not enough room in the output buffer"

				when Z_version_error then
					Result := "library version does not match header"
			else
				Result := "Unknown error"
			end
		end

	error_status: INTEGER

	last_compression_ratio: REAL

feature -- Status query

	has_error: BOOLEAN
		do
			Result := error_status > 0
		end

feature {NONE} -- Implementation

	new_compressed (source_ptr: POINTER; count, level: INTEGER; expected_compression_ratio: DOUBLE): SPECIAL [NATURAL_8]
		local
			status: INTEGER; compressed_count, upper_bound: INTEGER_64
			upper_compression_ratio, compression_ratio: DOUBLE
			done: BOOLEAN
		do
			error_status := 0
			upper_bound := c_compress_bound (count)
			upper_compression_ratio := upper_bound / count
			from
				compression_ratio := expected_compression_ratio
			until
				done or compression_ratio > upper_compression_ratio + 0.1
			loop
				compressed_count := upper_bound.min ((count * compression_ratio).rounded)

				create Result.make_filled (0, compressed_count.to_integer)
				status := c_compress2 (Result.base_address, $compressed_count, source_ptr, count, level)
				inspect status
					when Z_ok then
						Result.keep_head (compressed_count.to_integer)
						last_compression_ratio := compression_ratio.truncated_to_real
						done := True

					when Z_buf_error then
						compression_ratio := compression_ratio + 0.1

				else
					error_status := status
					done := True
				end
			end
		ensure
			compressed: Result.count > 0
		end

	new_decompressed (source_ptr: POINTER; count, orginal_count: INTEGER): SPECIAL [NATURAL_8]
		local
			status: INTEGER; decompressed_count: INTEGER_64
		do
			error_status := 0
			decompressed_count := orginal_count
			create Result.make_filled (0, decompressed_count.to_integer)
			status := c_uncompress (Result.base_address, $decompressed_count, source_ptr, count)
			inspect status
				when Z_ok then
					Result.keep_head (decompressed_count.to_integer)
					last_compression_ratio := (count / decompressed_count.to_integer).truncated_to_real
			else
				error_status := status
			end
		ensure
			same_count_as_original: orginal_count = Result.count
		end

end