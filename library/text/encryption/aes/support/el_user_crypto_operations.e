note
	description: "[
		Common cryptographic operations that require user interaction
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 14:14:47 GMT (Sunday 27th April 2025)"
	revision: "14"

frozen expanded class
	EL_USER_CRYPTO_OPERATIONS

inherit
	EL_USER_CRYPTO_OPERATIONS_I
		export
			{ANY} decrypt_file_with_aes, display_encrypted_file, encrypt_file_with_aes, encrypt_ftp_uri,
				encrypt_user_input_text, generate_pass_phrase_salt, set_validation_prompt, validate
		end

	EL_EXPANDED_ROUTINES

end