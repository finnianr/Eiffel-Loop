note
	description: "Reads private key from X509 .key file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 10:26:09 GMT (Thursday 22nd July 2021)"
	revision: "8"

deferred class
	EL_X509_KEY_READER_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as key_file_path,
			set_file_path as set_key_file_path,
			make as make_file_command
		export
			{NONE} all
			{ANY} execute, has_error, key_file_path, errors
		undefine
			do_command, new_command_parts
		redefine
			make_default
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		redefine
			do_command
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
			create lines.make (100)
			Precursor {EL_FILE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	lines: EL_ZSTRING_LIST

	phrase: ZSTRING

	private_key: EL_RSA_PRIVATE_KEY
		require
			has_lines: not lines.is_empty
		do
			if has_error then
				create Result.make_default
			else
				create Result.make_from_pkcs1 (lines)
			end
		end

feature -- Basic operations

	write_to_aes (aes_bit_count: INTEGER; a_output_path: detachable EL_FILE_PATH)
		-- exports key file at `key_file_path' to an AES encrypted file using `phrase' as credential
		-- if `not attached a_output_path' then writes to `key_file_path' with added "text.aes" extension

		require
			key_read: not has_error
		local
			export_file_path: EL_FILE_PATH; cipher_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			if attached a_output_path as path then
				export_file_path := path
			else
				export_file_path := key_file_path.twin
				export_file_path.add_extension ("text.aes")
			end
			create cipher_file.make_open_write (export_file_path)
			cipher_file.set_encrypter (create {EL_AES_ENCRYPTER}.make (phrase, aes_bit_count))
			across lines as line loop
				if is_lio_enabled then
					lio.put_line (line.item)
				end
				cipher_file.put_string (line.item)
				cipher_file.put_new_line
			end
			cipher_file.close
		end

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command)
		do
			Execution.put (phrase, Var_pass_phrase)
			Precursor {EL_CAPTURED_OS_COMMAND_I} (a_system_command)
			Execution.put (Empty_string, Var_pass_phrase)
		end

	do_with_lines (a_lines: like adjusted_lines)
			--
		do
			a_lines.do_all (agent lines.extend)
		end

feature {NONE} -- Constants

	Var_pass_phrase: STRING = "OPENSSL_PP"

end