note
	description: "[
		Menu driven shell of various cryptographic commands listed in function `new_command_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-26 8:36:31 GMT (Saturday 26th August 2023)"
	revision: "41"

class
	EL_CRYPTO_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		export
			{ANY} make
		redefine
			description
		end

	EL_USER_CRYPTO_OPERATIONS
		export
			{NONE} all
		end

create
	make

feature -- Constants

	Description: STRING = "Menu driven cryptographic tool"

feature {NONE} -- Implementation

	new_command_table: like command_table
		do
			create Result.make (<<
				["Decrypt AES encrypted file",			agent decrypt_file_with_aes],
				["Display AES encrypted file",			agent display_encrypted_file],
				["Encrypt file with AES encryption",	agent encrypt_file_with_aes],
				["Encrypt FTP url",							agent encrypt_ftp_url],
				["Encrypt input text as base-64",		agent encrypt_user_input_text (False)],
				["Encrypt input text as Eiffel array",	agent encrypt_user_input_text (True)],
				["Generate pass phrase salt",				agent generate_pass_phrase_salt]
			>>)
		end

end