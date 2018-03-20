note
	description: "Encrypt contents of a file adding the aes extension"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:28:22 GMT (Thursday 22nd February 2018)"
	revision: "5"

class
	PYXIS_ENCRYPTER

inherit
	EL_COMMAND

	EL_MODULE_LOG

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path: like source_path; a_output_path: like output_path; a_encrypter: like encrypter)
		do
			source_path  := a_source_path; output_path := a_output_path; encrypter := a_encrypter
			if output_path.is_empty then
				output_path := source_path.twin
				output_path.add_extension ("aes")
			end
		end

feature -- Access

	source_path: EL_FILE_PATH

	output_path: EL_FILE_PATH

feature -- Basic operations

	execute
		local
			in_file, out_file: PLAIN_TEXT_FILE; line: STRING; line_count: INTEGER
		do
			log.enter ("execute")
			lio.put_path_field ("Encrypting", source_path); lio.put_new_line
			create in_file.make_open_read (source_path)
			create out_file.make_open_write (output_path)

			from until in_file.end_of_file loop
				in_file.read_line
				line := in_file.last_string
				line_count := line_count + 1
				if line_count <= 2 then
					out_file.put_string (line)
				elseif not line.is_empty then
					out_file.put_string (encrypter.base64_encrypted (line))
				end
				out_file.put_new_line
			end
			out_file.close; in_file.close
			log.exit
		end

feature {NONE} -- Implementation

	encrypter: EL_AES_ENCRYPTER

end
