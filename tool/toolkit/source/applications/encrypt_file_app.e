note
	description: "Summary description for {ENCRYPT_STD_INPUT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-14 10:17:27 GMT (Thursday 14th March 2013)"
	revision: "2"

class
	ENCRYPT_FILE_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_ENCRYPTABLE

	EL_MODULE_BASE_64

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create input_path.make
			set_attribute_from_command_opt (input_path, "in", "input file to encrypt")
			create output_path.make_from_string (input_path)
			output_path.add_extension ("aes")
		end

feature -- Basic operations

	run
			--

		local
			cipher_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
			plain_text_file: PLAIN_TEXT_FILE
		do
			log.enter ("run")
			set_encrypter_from_phrase (User_input.line ("Enter pass phrase"))

			log_or_io.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
			log_or_io.put_new_line
			log_or_io.put_line ("Key: " + encrypter.out)

			create plain_text_file.make_open_read (input_path)
			create cipher_file.make_open_write (output_path)
			cipher_file.set_encrypter (encrypter)

			from plain_text_file.read_line until plain_text_file.after loop
				cipher_file.put_string (plain_text_file.last_string)
				cipher_file.put_new_line
				plain_text_file.read_line
			end
			cipher_file.close
			plain_text_file.close

			log.exit
		end

feature -- Element change

	set_encrypter_from_phrase (pass_phrase: STRING)
			--
		do
			create encrypter.make_256 (pass_phrase)
		end

feature {NONE} -- Implementation

	input_path: FILE_NAME

	output_path: FILE_NAME

feature {NONE} -- Constants

	Option_name: STRING = "encrypt_file"

	Description: STRING = "Encrypt standard input with pass phrase"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{ENCRYPT_FILE_APP}, "*"]
			>>
		end

end
