note
	description: "[
		Encrypts a file using AES cryptography
		
		Usage:
			el_toolkit -pyxis_encrypt -in <input-name> -out <output-name>
			
		If `-out' is not specified, it outputs the file as `<input-name>.aes'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:08:27 GMT (Tuesday 10th November 2020)"
	revision: "13"

class
	PYXIS_ENCRYPTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_ENCRYPTER]
		rename
			command as pyxis_encrypter,
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name, normal_initialize, pyxis_encrypter
		end

	EL_MODULE_USER_INPUT

	EL_MODULE_ENCRYPTION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
		do
			if not is_test_mode then
				create aes_encrypter.make (User_input.line ("Enter pass phrase"), 256)
				lio.put_new_line
			end
			Precursor
		end

feature -- Basic operations

	test_run
			--
		do
			-- Passed 19 Jan 2016
			Test.do_file_test ("pyxis/localization/credits.xml.pyx", agent test_translation, 1781642312)
		end

feature -- Testing

	test_translation (a_file_path: EL_FILE_PATH)
			--
		local
			table, decrypted_table: EL_TRANSLATION_TABLE
			plain_text: STRING
		do
			log.enter ("test_translation")
			create aes_encrypter.make ("happydays", 128)
			create pyxis_encrypter.make (a_file_path, create {EL_FILE_PATH}, aes_encrypter)
			normal_run
			aes_encrypter.reset
			plain_text := Encryption.plain_pyxis (pyxis_encrypter.output_path, aes_encrypter)

			across << "en", "de" >> as language loop
				log.put_labeled_string ("language", language.item)
				log.put_new_line
				create decrypted_table.make_from_pyxis_source (language.item, plain_text)
				create table.make_from_pyxis (language.item, a_file_path)
				across table as translation loop
					decrypted_table.search (translation.key)
					if decrypted_table.found and then translation.item ~ decrypted_table.found_item then
						log.put_labeled_string (translation.key, "OK")
					else
						log.put_labeled_string (translation.key, "ERROR")
						log.put_new_line
						if decrypted_table.found then
							log.put_string_field_to_max_length ("Original", translation.item, 240)
							log.put_new_line
							log.put_line ("NOT EQUAL TO")
							log.put_string_field_to_max_length ("Decrypted", decrypted_table.found_item, 240)
						else
							log.put_line ("Cannot find decrypted key")
						end
						log.put_new_line
					end
					log.put_new_line
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path")
			>>
		end

	default_make: PROCEDURE [like pyxis_encrypter]
		do
			Result := agent {like pyxis_encrypter}.make ("", "", aes_encrypter)
		end

feature {NONE} -- Internal attributes

	aes_encrypter: EL_AES_ENCRYPTER

	pyxis_encrypter: PYXIS_ENCRYPTER

feature {NONE} -- Constants

	Description: STRING = "Encrypt content of pyxis file"

	Option_name: STRING = "pyxis_encrypt"

end