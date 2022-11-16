note
	description: "Command to to Filter out all invalid UTF-8 lines from file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	FILTER_INVALID_UTF_8

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LOG

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path: like source_path)
		do
			source_path  := a_source_path
			output_path := source_path.without_extension
			output_path.add_extension ("fixed")
			output_path.add_extension (source_path.extension)
		end

feature -- Constants

	Description: STRING = "Filter out all invalid UTF-8 lines from file"

feature -- Basic operations

	execute
		local
			in_file, out_file: PLAIN_TEXT_FILE; line: STRING
			bad_count: INTEGER; c: EL_UTF_CONVERTER
		do
			log.enter ("execute")
			lio.put_path_field ("Filtering", source_path)
			lio.put_new_line

			create in_file.make_open_read (source_path)
			create out_file.make_open_write (output_path)

			from until in_file.end_of_file loop
				in_file.read_line
				line := in_file.last_string
				if c.is_valid_utf_8_string_8 (line) then
					if out_file.position > 0 then
						out_file.put_new_line
					end
					out_file.put_string (line)
				else
					bad_count := bad_count + 1
				end
			end
			out_file.close; in_file.close
			lio.put_integer_field ("Found bad lines", bad_count)
			lio.put_new_line
			log.exit
		end

feature {NONE} -- Internal attributes

	output_path: FILE_PATH

	source_path: FILE_PATH

end