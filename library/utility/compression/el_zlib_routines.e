note
	description: "[https://www.zlib.net/manual.html Zlib library] routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 10:29:22 GMT (Tuesday 20th August 2024)"
	revision: "10"

class
	EL_ZLIB_ROUTINES

inherit
	EL_ZLIB_API

	EL_MODULE_EXCEPTION

feature -- Conversion

	compressed (source: MANAGED_POINTER; level: INTEGER; expected_compression_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: Level_interval.has (level)
		do
			Result := new_compressed (source.item, source.count, level, expected_compression_ratio)
		end

	compressed_string (source: STRING; level: INTEGER; expected_compression_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: Level_interval.has (level)
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

	error_message: EL_STRING_8_LIST
		local
			table: EL_IMMUTABLE_STRING_8_TABLE
		do
			create table.make_code_map (Code_table)
			if table.has_key_code (error_status) then
				create Result.make_with_lines (table.found_item_unindented)
			else
				Result := "Unknown error"
			end
		end

	error_status: INTEGER

	last_compression_ratio: REAL

feature -- Constants

	Level_interval: INTEGER_INTERVAL
		once
			Result := -1 |..| 9
		end

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

feature {NONE} -- Constants

	Code_table: STRING = "[
		0:
			No error, the operation was successful.
		1:
			The end of the input stream was reached successfully during decompression.
		2:
			A preset dictionary is needed for decompression. This happens when the
			compressed data was created using a dictionary.
		-1:
			A generic error code indicating an I/O error. It typically means there
			was an error in the file handling outside of zlib.
		-2:
			An error with the stream state, which might indicate an invalid compression
			level, inconsistent internal state, or invalid parameter passed to a function.
		-3:
			The compressed data stream is corrupted, or the data was incomplete.
		-4:
			Insufficient memory to complete the operation.
		-5:
			The buffer provided is not large enough to hold the output or input data.
			This often occurs when the output buffer is too small during compression
			or decompression.
		-6:
			The zlib library version used is incompatible with the version of the library
			expected by the application.
	]"

end