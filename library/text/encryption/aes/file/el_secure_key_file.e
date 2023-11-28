note
	description: "Secure encrypted file that can be temporarily unlocked as plain text file"
	notes: "[
		Password salt and digest is kept in the sub-application configuration directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-28 10:04:11 GMT (Tuesday 28th November 2023)"
	revision: "7"

class
	EL_SECURE_KEY_FILE

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			field_included as is_any_field,
			xml_naming as eiffel_naming
		redefine
			new_transient_fields
		end

	EL_MODULE_CHECKSUM; EL_MODULE_DIRECTORY; EL_MODULE_FILE

	EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	EL_SHARED_PASSPHRASE_TEXTS

create
	make

feature {NONE} -- Initialization

	make (a_key_path: FILE_PATH)
		require
			absolute_path: a_key_path.is_absolute
		local
			xml_path: FILE_PATH; phrase: ZSTRING; location_digest: STRING
		do
			key_path := a_key_path
--			Make base name unique
			location_digest := Checksum.string (a_key_path).to_hex_string
			xml_path := Directory.Sub_app_configuration + Base_template #$ [a_key_path.base_name, location_digest]

			secure_path := a_key_path.twin
			secure_path.add_extension (Secure)

			if xml_path.exists then
				make_from_file (xml_path)
			else
				make_default
				phrase := User_input.line (Text.secure_file_prompt #$ [a_key_path.base])
				create credential.make_valid (phrase)
				File_system.make_directory (xml_path.parent)
				file_path := xml_path
				store
			end
		end

feature -- Status query

	is_locked: BOOLEAN
		do
			Result := not is_unlocked
		end

	is_unlocked: BOOLEAN
		do
			Result := key_path.exists
		end

feature -- Basic operations

	lock
		local
			secure_file: EL_ENCRYPTED_FILE; key_file: RAW_FILE; i, byte_count: INTEGER
			user: EL_USER_CRYPTO_OPERATIONS
		do
			if not secure_path.exists then
				if not credential.is_valid then
					user.validate (credential, Void)
				end
				create secure_file.make_open_write (secure_path, credential.new_aes_encrypter (256))
				secure_file.put_data (File.data (key_path))
				secure_file.close
			end
			byte_count := File.byte_count (key_path)
			-- Overwrite file with zeroes
			create key_file.make_open_write (key_path)
			from i := 1  until i >= byte_count loop
				key_file.put_character ('%U')
				i := i + 1
			end
			key_file.close
			key_file.delete
		ensure
			locked: is_locked
		end

	unlock
		local
			secure_file: EL_ENCRYPTED_FILE; key_file: RAW_FILE
			user: EL_USER_CRYPTO_OPERATIONS
		do
			if is_locked then
				user.validate (credential, Void)
				create secure_file.make_open_read (secure_path, credential.new_aes_encrypter (256))
				create key_file.make_open_write (key_path)
				if attached secure_file.plain_data as data then
					key_file.put_managed_pointer (data, 0, data.count)
					key_file.close
				end
				secure_file.close
			end
		ensure
			unlocked: is_unlocked
		end

feature -- Basic operations

	remove_config
		do
			File_system.remove_file (file_path)
		end

feature {NONE} -- Implementation

	new_transient_fields: STRING
		do
			Result := Precursor + ", key_path, secure_path"
		end

feature {NONE} -- Internal attributes

	credential: EL_BUILDABLE_AES_CREDENTIAL

	key_path: FILE_PATH

	secure_path: FILE_PATH

feature {NONE} -- Constants

	Base_template: ZSTRING
		once
			Result := "%S-%S.xml"
		end

	Secure: ZSTRING
		once
			Result := "secure"
		end

end