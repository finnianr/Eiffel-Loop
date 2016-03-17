note
	description: "Summary description for {EL_ID3_HEADER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:47:04 GMT (Friday 18th December 2015)"
	revision: "5"

class
	EL_ID3_HEADER

create
	make, make_from_file

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path)
			make_from_file (l_file)
			l_file.close
		end

	make_from_file (file: RAW_FILE)
		do
			create buffer.make (Header_size)
			file.go (0)
			read_from_file (file, "ID3")
			if not is_valid then
				-- look for footer at end
				file.recede (Header_size - 1)
				read_from_file (file, "3DI")
			end
		end

feature -- Access

	version_name: ZSTRING
		do
			Result := "ID3v2.%S.%S"
			Result.substitute_tuple ([major_version, revision])
		end

	version: REAL
		do
			Result := ((20 + major_version) / 10).truncated_to_real
		end

	major_version: NATURAL_8

	revision: NATURAL_8
		-- version revision number

	id: STRING

feature -- Element change

	set_version (a_version: like version)
		require
			valid_version: a_version >= 2.0
		do
			major_version := ((a_version * 10).rounded \\ 20).to_natural_8
		end

feature -- Measurement

	size: INTEGER

	total_size: INTEGER
		do
			if is_valid then
				Result := size + Header_size
				if has_footer then
					Result := Result + Header_size
				end
			end
		end

feature -- Status query

	is_valid: BOOLEAN

	has_footer: BOOLEAN
		do
			if major_version = 4 then
				Result := flags.bit_test (4)
			end
		end

	is_experimental: BOOLEAN
		do
			Result := flags.bit_test (5)
		end

	has_extended_header: BOOLEAN
		do
			Result := flags.bit_test (6)
		end

	is_unsynchronized: BOOLEAN
		do
			Result := flags.bit_test (7)
		end

feature {NONE} -- Implementation

	read_from_file (file: RAW_FILE; marker_id: STRING)
		local
			pos, byte: INTEGER
		do
			file.read_to_managed_pointer (buffer, 0, Header_size)
			read_id

			major_version := buffer.read_natural_8 (3)
			revision := buffer.read_natural_8 (4)
			flags := buffer.read_natural_8 (5)

			if id ~ marker_id then
				is_valid := True
				from pos := 3 until pos < 0 loop
					byte := buffer.read_integer_8 (9 - pos).to_integer
					byte := byte |<< (pos * 7)
					size := size | byte
					pos := pos - 1
				end
			end
		end

feature {NONE} -- Implementation

	read_id
		do
			create id.make_filled ('%U', 3)
			id.area.base_address.memory_copy (buffer.item, 3)
		end

	flags: NATURAL_8

	buffer: MANAGED_POINTER

feature -- Constants

	Header_size: INTEGER = 10

end
