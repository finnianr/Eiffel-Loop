note
	description: "Windows, Latin, or UTF encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-20 7:26:09 GMT (Monday 20th May 2024)"
	revision: "12"

class
	EL_ENCODING

inherit
	EL_ENCODING_BASE
		rename
			encoding as code,
			valid_encoding as is_valid
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_name,
			to_string as name
		end

	EL_STRING_8_CONSTANTS

create
	make_default, make, make_from_general, make_from_name, make_from_other

convert
	make_from_other ({EL_ENCODING_BASE})

feature {NONE} -- Initialization

	make_from_name (a_name: STRING)
		do
			make_default
			set_from_name (a_name)
		end

	make_from_other (other: EL_ENCODING_BASE)
		do
			make (other.encoding)
		end

feature -- Access

	file_info (file: PLAIN_TEXT_FILE): TUPLE [encoding: NATURAL; bom_count: INTEGER; detected: BOOLEAN]
		-- return info about file encoding deduced from presence of either a byte order mark or
		-- a little endian carriage return
		require
			closed_or_readable: file.is_closed or else file.is_open_read
		local
			is_open_read: BOOLEAN; c: UTF_CONVERTER
			line_one: STRING; position: INTEGER
		do
			create Result
			if file.is_open_read then
				is_open_read := True
				position := file.position
				file.go (0)
			else
				file.open_read
			end
			if file.count > 0 then
				-- Find first non-empty line
				from line_one := Empty_string_8 until line_one.count > 0 or else file.end_of_file loop
					file.read_line
					line_one := file.last_string
				end
				if line_one.starts_with (c.Utf_8_bom_to_string_8) then
					Result.bom_count := c.Utf_8_bom_to_string_8.count
					Result.encoding := Utf_class | 8

				elseif line_one.starts_with (c.utf_16le_bom_to_string_8) then
					Result.bom_count := c.utf_16le_bom_to_string_8.count
					Result.encoding := Utf_class | 16

				elseif line_one.has_substring (Little_endian_carriage_return) then
					Result.encoding := Utf_class | 16
				end
			end
			Result.detected := Result.encoding.to_boolean
			if is_open_read then
				file.go (position)
			else
				file.close
			end
		ensure
			same_file_status: old file.is_open_read = file.is_open_read
			same_position: old file.position = file.position
		end

feature {NONE} -- Constants

	Little_endian_carriage_return: STRING = "%R%U"

end