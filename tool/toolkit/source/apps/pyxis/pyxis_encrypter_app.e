note
	description: "[
		Command line interface to [$source PYXIS_ENCRYPTER] which encrypts a file using AES cryptography
		
		Usage:
			el_toolkit -pyxis_encrypt -in <input-name> -out <output-name>
			
		If `-out' is not specified, it outputs the file as `<input-name>.aes'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 10:38:13 GMT (Monday 10th January 2022)"
	revision: "15"

class
	PYXIS_ENCRYPTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [PYXIS_ENCRYPTER]
		rename
			command as pyxis_encrypter
		redefine
			Option_name
		end

	EL_MODULE_USER_INPUT

create
	make

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
		do
			create Result.make (User_input.line ("Enter pass phrase"), 256)
			lio.put_new_line
		end

feature {NONE} -- Constants

	Description: STRING = "Encrypt content of pyxis file"

	Option_name: STRING = "pyxis_encrypt"

end