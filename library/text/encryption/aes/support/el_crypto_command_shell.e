note
	description: "[
		Menu driven shell of various cryptographic commands listed in function `new_command_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-27 9:41:04 GMT (Saturday 27th April 2024)"
	revision: "42"

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
				["Encrypt FTP URI as Pyxis markup",		agent encrypt_ftp_uri],
				["Encrypt input text as base-64",		agent encrypt_user_input_text (False)],
				["Encrypt input text as Eiffel array",	agent encrypt_user_input_text (True)],
				["Generate pass phrase salt",				agent generate_pass_phrase_salt]
			>>)
		end

end