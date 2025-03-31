note
	description: "Github configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 11:20:47 GMT (Monday 31st March 2025)"
	revision: "17"

class
	GITHUB_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make,
			element_node_fields as All_fields
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			Precursor (a_file_path)
			sg.super_32 (rsync_template).replace_character ('%N', ' ')
		end

feature -- Access

	encrypted_access_token: STRING

	github_dir: DIR_PATH

	rsync_template: STRING

	source_dir: DIR_PATH

	manifest_path: ZSTRING
		-- relative to `source_dir'

	source_manifest_path: ZSTRING
		-- absolute path to source manifest
		do
			Result := source_dir + manifest_path
		end

	user_name: STRING

feature -- Factory

	new_credentials_text (plain_text: BOOLEAN): STRING
		local
			decrypter: EL_AES_ENCRYPTER; user: EL_USER_CRYPTO_OPERATIONS
		do
			if plain_text then
				user.validate (credential, Void)
				decrypter := credential.new_aes_encrypter (256)
				Result := Credential_template #$ [user_name, decrypter.decrypted_base_64 (encrypted_access_token)]
			else
				Result := Credential_template #$ [user_name, encrypted_access_token]
			end
		end

feature {NONE} -- Internal attributes

	credential: EL_BUILDABLE_AES_CREDENTIAL

feature {NONE} -- Constants

	Credential_template: ZSTRING
		once
			Result := "https://%S:%S@github.com"
		end

end