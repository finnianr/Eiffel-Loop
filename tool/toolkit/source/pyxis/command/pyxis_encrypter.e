note
	description: "Encrypt contents of a file adding the AES extension"
	tests: "${PYXIS_ENCRYPTER_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 7:59:08 GMT (Thursday 22nd August 2024)"
	revision: "17"

class
	PYXIS_ENCRYPTER

inherit
	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_LIO

	EL_MODULE_FILE

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path, a_output_path: FILE_PATH; a_encrypter: like encrypter)
		do
			source_path  := a_source_path; encrypter := a_encrypter
			output_path := a_source_path.related (a_output_path, "aes")
		end

feature -- Access

	Description: STRING = "Encrypt content of pyxis file"

	output_path: FILE_PATH

	source_path: FILE_PATH

feature -- Basic operations

	execute
		local
			out_file: PLAIN_TEXT_FILE
		do
			lio.put_path_field ("Encrypting", source_path)
			lio.put_new_line
			create out_file.make_open_write (output_path)

			across File.plain_text_lines (source_path) as line loop
				if line.cursor_index <= 2 then
					out_file.put_string (line.item)
				elseif not line.item.is_empty then
					out_file.put_string (encrypter.base_64_encrypted (line.item))
				end
				out_file.put_new_line
			end
			out_file.close
		end

feature {NONE} -- Implementation

	encrypter: EL_AES_ENCRYPTER

end