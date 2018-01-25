note
	description: "Summary description for {MP3_AUDIO_SIGNATURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-23 12:49:36 GMT (Tuesday 23rd January 2018)"
	revision: "5"

class
	MP3_IDENTIFIER

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		redefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_file_path: like file_path)
		local
			header: EL_ID3_HEADER; mp3_file: RAW_FILE
		do
			file_path := a_file_path
			create mp3_file.make_open_read (file_path); create header.make_from_file (mp3_file)
			if header.is_valid then
				create audio_id.make_from_array (new_signature (mp3_file, header))
			else
				create audio_id.make_default
			end
			mp3_file.close
		end

	make_default
		do
			Precursor
			create audio_id.make_default
			create file_path
		end

feature -- Access

	audio_id: EL_UUID

	file_path: EL_FILE_PATH

feature {NONE} -- Implementation

	is_padding (n: NATURAL): BOOLEAN
			-- True if all hexadecimal digits are the same
		local
			first, hex_digit: NATURAL; i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 7 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 8 and then hex_digit = first
		end

	new_signature (mp3_file: RAW_FILE; header: EL_ID3_HEADER): ARRAY [NATURAL_8]
		local
			md5: MD5; i, data_size: INTEGER; n: NATURAL
		do
			create Result.make_filled (0, 1, 16); create md5.make

			data_size := mp3_file.count - header.total_size
			md5.sink_natural_32_be (data_size.to_natural_32)
			mp3_file.go (header.total_size + data_size // 10)
			from i := 1 until i > 64 or mp3_file.end_of_file loop
				mp3_file.read_natural_32
				n := mp3_file.last_natural_32
				if not is_padding (n) then
					md5.sink_natural_32_be (n)
					i := i + 1
				end
			end
			md5.do_final (Result.area, 0)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 0
end
