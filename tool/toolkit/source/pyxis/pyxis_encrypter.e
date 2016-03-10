note
	description: "Encrypt contents of Pyxis file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 18:58:02 GMT (Tuesday 25th June 2013)"
	revision: "3"

class
	PYXIS_ENCRYPTER

inherit
	EL_COMMAND

	EL_MODULE_LOG

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (a_source_path: like source_path; a_output_path: like output_path; a_pass_phrase: like pass_phrase)
		do
			source_path  := a_source_path; output_path := a_output_path; pass_phrase := a_pass_phrase
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
			--
		local
			in_file_list: EL_FILE_LINE_SOURCE
			out_file: PLAIN_TEXT_FILE
			encrypter: EL_AES_ENCRYPTER
		do
			log.enter ("execute")
			log_or_io.put_path_field ("Encrypting", source_path); log_or_io.put_new_line
			create encrypter.make_256 (pass_phrase)
			create in_file_list.make (source_path)
			create out_file.make_open_write (output_path.unicode)
			from in_file_list.start until in_file_list.after loop
				if in_file_list.index <= 2 or in_file_list.item.is_empty then
					out_file.put_string (in_file_list.item)
				else
					out_file.put_string (encrypter.base64_encrypted (in_file_list.item))
				end
				out_file.put_new_line
				in_file_list.forth
			end
			out_file.close; in_file_list.close
			log.exit
		end

feature {NONE} -- Implementation

	pass_phrase: STRING

end
