note
	description: "[
		${EL_CRYPTO_COMMAND_SHELL} with addition of RSA public-key cryptography operations
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_RSA_CRYPTO_COMMAND_SHELL

inherit
	EL_CRYPTO_COMMAND_SHELL
		redefine
			new_command_table
		end

	EL_RSA_USER_CRYPTO_OPERATIONS
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	new_command_table: like command_table
		do
			Result := Precursor
			Result.merge_array (<<
				["Export private.key file to private.key.dat",		 agent export_x509_private_key_to_aes],
				["Write crt public key as Eiffel asssignment",		 agent write_x509_public_key_code_assignment],
				["Write CSV list as RSA signed Eiffel assignments", agent write_signed_CSV_list_with_x509_private_key]
			>>)
		end

end