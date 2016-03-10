note
	description: "Summary description for {PYXIS_ENCRYPTER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 10:45:03 GMT (Monday 24th June 2013)"
	revision: "3"

class
	PYXIS_ENCRYPTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [PYXIS_ENCRYPTER]
		rename
			command as encrypter
		redefine
			Option_name, normal_initialize, encrypter, normal_run
		end

	EL_MODULE_USER_INPUT

	EL_MODULE_ENCRYPTION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
		do
			create pass_phrase.make_empty
			Precursor
		end

feature -- Basic operations

	normal_run
		do
			if not is_test_mode then
				pass_phrase.share (User_input.line ("Enter pass phrase"))
				log_or_io.put_new_line
			end
			precursor
		end

feature -- Testing

	test_run
			--
		do
			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_conversion, 150336385)
		end

	test_conversion (a_file_path: EL_FILE_PATH)
			--
		local
			decrypter: EL_AES_ENCRYPTER
		do
			pass_phrase.share ("happydays")
			create encrypter.make (a_file_path, create {EL_FILE_PATH}, pass_phrase)
			normal_run
			create decrypter.make_256 (pass_phrase)
			log.put_string_field_to_max_length ("Pyxis", Encryption.plain_pyxis (encrypter.output_path, decrypter), 240)
		end

feature {NONE} -- Implementation

	encrypter: PYXIS_ENCRYPTER

	make_action: PROCEDURE [like encrypter, like default_operands]
		do
			Result := agent encrypter.make
		end

	default_operands: TUPLE [
		source_path, output_path: EL_FILE_PATH; pass_phrase: STRING
	]
		do
			create Result
			Result.source_path := ""
			Result.output_path := ""
			Result.pass_phrase := pass_phrase
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("in", "Input file path"),
				optional_argument ("out", "Output file path")
			>>
		end

	pass_phrase: STRING

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_encrypt"

	Description: STRING = "Encrypt content of pyxis file"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PYXIS_ENCRYPTER_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{PYXIS_ENCRYPTER}, "*"]
			>>
		end

end
