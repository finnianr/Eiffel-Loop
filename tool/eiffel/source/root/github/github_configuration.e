note
	description: "Github configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 12:19:30 GMT (Saturday 14th August 2021)"
	revision: "3"

class
	GITHUB_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			element_node_type as	Text_element_node
		redefine
			make, make_default, new_instance_functions
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
			--
		local
			s: EL_STRING_8_ROUTINES
		do
			Precursor (a_file_path)
			s.replace_character (rsync_template, '%N', ' ')
		end

	make_default
		do
			Precursor
		end

feature -- Access

	new_credential_decrypter: EL_AES_ENCRYPTER
		do
			if not credential.is_phrase_set then
				credential.ask_user
			end
			Result := credential.new_aes_encrypter (256)
		end

	github_dir: EL_DIR_PATH

	license_path: ZSTRING
		-- relative to `source_dir'

	rsync_template: STRING

	source_dir: EL_DIR_PATH

	source_manifest_path: ZSTRING
		-- relative to `source_dir'

feature {NONE} -- Factory

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: like credential do create Result.make_default end
			>>)
		end

feature {NONE} -- Internal attributes

	credential: EL_BUILDABLE_AES_CREDENTIAL

	encrypted_access_token: STRING

end