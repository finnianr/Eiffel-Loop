note
	description: "Reads private key from X509 certificate file with extension ''.key''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-23 18:23:36 GMT (Friday 23rd July 2021)"
	revision: "9"

deferred class
	EL_X509_PRIVATE_READER_COMMAND_I

inherit
	EL_X509_CERTIFICATE_READER_COMMAND_I
		rename
			rsa_key as private_key,
			crt_file_path as key_file_path,
			make as make_file_command,
			find_public_key as find_private_key
		redefine
			do_command, do_with_lines, make_default, Data_fields, Field_names
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make (a_key_file_path: like key_file_path; a_phrase: ZSTRING)
		do
			make_file_command (a_key_file_path)
			phrase := a_phrase
		end

	make_default
			--
		do
			create phrase.make_empty
			Precursor
		end

feature -- Access

	phrase: ZSTRING

	private_key: EL_RSA_PRIVATE_KEY
		do
			if has_error then
				create Result.make_default
			else
				create Result.make_from_pkcs1_table (data_table)
			end
		end

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command)
		do
			Execution.put (phrase, Var_pass_phrase)
			Precursor (a_system_command)
			Execution.put (Empty_string, Var_pass_phrase)
		end

	do_with_lines (a_lines: like adjusted_lines)
			--
		do
			parse_lines (agent find_private_key, a_lines)
		end

feature {NONE} -- Constants

	Data_fields: EL_ZSTRING_LIST
		once
			Result := "modulus, publicExponent, privateExponent, prime1, prime2, exponent1"
		end

	Field_names: STRING
		once
			Result := "publicExponent, Private-Key, Serial Number"
		end

	Var_pass_phrase: STRING = "OPENSSL_PP"

end