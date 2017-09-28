note
	description: "Summary description for {FILTER_INVALID_UTF_8_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 16:32:09 GMT (Sunday 3rd September 2017)"
	revision: "1"

class
	FILTER_INVALID_UTF_8_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_UTF

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_source_path: like source_path)
		do
			source_path  := a_source_path
			output_path := source_path.without_extension
			output_path.add_extension ("fixed")
			output_path.add_extension (source_path.extension)
		end

feature -- Basic operations

	execute
		local
			in_file, out_file: PLAIN_TEXT_FILE; line: STRING
			bad_count: INTEGER
		do
			log.enter ("execute")
			lio.put_path_field ("Filtering", source_path)
			lio.put_new_line

			create in_file.make_open_read (source_path)
			create out_file.make_open_write (output_path)

			from until in_file.end_of_file loop
				in_file.read_line
				line := in_file.last_string
				if UTF.is_valid_utf_8_string_8 (line) then
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

	source_path: EL_FILE_PATH

	output_path: EL_FILE_PATH


end
