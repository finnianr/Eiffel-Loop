note
	description: "[
		Menu driven shell of various cryptographic commands listed in function `new_command_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 8:43:16 GMT (Wednesday 16th August 2023)"
	revision: "40"

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
				["Display encrypted input text as base-64",		 agent display_encrypted_text (False)],
				["Display encrypted input text as Eiffel array", agent display_encrypted_text (True)],
				["Display AES encrypted file",						 agent display_encrypted_file],
				["Decrypt AES encrypted file",						 agent decrypt_file_with_aes],
				["Encrypt file with AES encryption",				 agent encrypt_file_with_aes],
				["Generate pass phrase salt",							 agent generate_pass_phrase_salt]
			>>)
		end

end