note
	description: "[https://www.zlib.net/manual.html Zlib library] routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-29 15:51:55 GMT (Thursday 29th August 2024)"
	revision: "14"

class
	EL_ZLIB_ROUTINES_IMP

inherit
	EL_ZLIB_API

	EL_MODULE_EXCEPTION

feature -- Conversion

	compressed (source: MANAGED_POINTER; level: INTEGER; expected_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: Level_interval.has (level)
		do
			Result := new_compressed (source.item, source.count, level, expected_ratio)
		end

	compressed_string (source: STRING; level: INTEGER; expected_ratio: DOUBLE): SPECIAL [NATURAL_8]
		require
			valid_level: Level_interval.has (level)
		do
			Result := new_compressed (source.area.base_address, source.count, level, expected_ratio)
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

	error_message: EL_ZSTRING_LIST
		do
			create Result.make_with_lines (Code_table [error_code])
		end

	error_code: INTEGER

	last_ratio: DOUBLE
		-- compression ratio of last successful call to `new_compressed'

feature -- Constants

	Level_interval: INTEGER_INTERVAL
		once
			Result := -1 |..| 9
		end

feature -- Status query

	has_error: BOOLEAN
		do
			Result := error_code > 0
		end

feature {NONE} -- Implementation

	new_compressed (source_ptr: POINTER; count, level: INTEGER; expected_ratio: DOUBLE): SPECIAL [NATURAL_8]
		-- compress data at `source_ptr' using `level' compression
		-- with expected compression ratio of `expected_ratio'
		local
			upper_bound, additional_space, i, compressed_count: INTEGER; n64_compressed_count: NATURAL_64
			done: BOOLEAN
		do
			error_code := 0; last_ratio := 0
			upper_bound := c_compress_bound (count.to_natural_64).to_integer_32
			create Result.make_filled (0, (count * expected_ratio).rounded.max (5))
			from until done or (Result.capacity - additional_space) > upper_bound loop
				n64_compressed_count := Result.capacity.to_natural_32
				error_code := c_compress2 (Result.base_address, $n64_compressed_count, source_ptr, count.to_natural_32, level)
				inspect error_code
					when Z_ok then
						compressed_count := n64_compressed_count.to_integer_32
						Result.keep_head (compressed_count)
						last_ratio := compressed_count / count
						done := True

					when Z_buf_error then
						additional_space := (Result.capacity // 3).max (5)
						Result := Result.aliased_resized_area_with_default (0, Result.capacity + additional_space)

				else
					done := True
				end
				i := i + 1
			end
		ensure
			compressed: Result.count > 0
		end

	new_decompressed (source_ptr: POINTER; count, orginal_count: INTEGER): SPECIAL [NATURAL_8]
		local
			n64_decompressed_count: NATURAL_64; decompressed_count: INTEGER
		do
			error_code := 0
			n64_decompressed_count := orginal_count.to_natural_32
			create Result.make_filled (0, orginal_count)
			error_code := c_uncompress (Result.base_address, $n64_decompressed_count, source_ptr, count.to_natural_32)
			decompressed_count := n64_decompressed_count.to_integer_32
			inspect error_code
				when Z_ok then
					Result.keep_head (decompressed_count)
					last_ratio := count / decompressed_count
			else
			end
		ensure
			same_count_as_original: orginal_count = Result.count
		end

feature {NONE} -- Constants

	Code_table: EL_CODE_TEXT_TABLE
		once
			create Result.make_with_default ("Unknown error", "[
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
			]")
		end

end