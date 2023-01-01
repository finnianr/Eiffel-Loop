note
	description: "Github configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 17:58:54 GMT (Friday 30th December 2022)"
	revision: "12"

class
	GITHUB_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make,
			element_node_fields as All_fields
		redefine
			make, new_instance_functions
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		local
			s: EL_STRING_8_ROUTINES
		do
			Precursor (a_file_path)
			s.replace_character (rsync_template, '%N', ' ')
		end

feature -- Access

	encrypted_access_token: STRING

	github_dir: DIR_PATH

	rsync_template: STRING

	source_dir: DIR_PATH

	source_manifest_path: ZSTRING
		-- relative to `source_dir'

	user_name: STRING

feature -- Factory

	new_credentials_text (plain_text: BOOLEAN): STRING
		local
			decrypter: EL_AES_ENCRYPTER
		do
			if plain_text then
				if not credential.is_phrase_set then
					credential.ask_user
				end
				decrypter := credential.new_aes_encrypter (256)
				Result := Credential_template #$ [user_name, decrypter.decrypted_base_64 (encrypted_access_token)]
			else
				Result := Credential_template #$ [user_name, encrypted_access_token]
			end
		end

feature {NONE} -- Factory

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: like credential do create Result.make_default end
			>>)
		end

feature {NONE} -- Internal attributes

	credential: EL_BUILDABLE_AES_CREDENTIAL

feature {NONE} -- Constants

	Credential_template: ZSTRING
		once
			Result := "https://%S:%S@github.com"
		end

end