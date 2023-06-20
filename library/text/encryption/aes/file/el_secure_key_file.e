note
	description: "Secure encrypted file that can be temporarily unlocked as plain text file"
	notes: "[
		Password salt and digest is kept in the sub-application configuration directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 16:53:37 GMT (Tuesday 20th June 2023)"
	revision: "3"

class
	EL_SECURE_KEY_FILE

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			field_included as is_any_field,
			xml_naming as eiffel_naming
		redefine
			Transient_fields
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_TUPLE; EL_MODULE_USER_INPUT
	
	EL_SHARED_PASSPHRASE_TEXTS

create
	make

feature {NONE} -- Initialization

	make (a_key_path: FILE_PATH)
		require
			absolute_path: a_key_path.is_absolute
		local
			xml_path: FILE_PATH; phrase: ZSTRING
		do
			key_path := a_key_path
			xml_path := Directory.Sub_app_configuration + a_key_path.base
			xml_path.add_extension (Extension.xml)

			secure_path := a_key_path.twin
			secure_path.add_extension (Extension.secure)

			if xml_path.exists then
				make_from_file (xml_path)
			else
				make_default
				phrase := User_input.line (Text.secure_file_prompt #$ [a_key_path.base])
				create credential.make (phrase)
				File_system.make_directory (xml_path.parent)
				file_path := xml_path
				store
			end
		end

feature -- Status query

	is_unlocked: BOOLEAN
		do
			Result := key_path.exists
		end

	is_locked: BOOLEAN
		do
			Result := not is_unlocked
		end

feature -- Basic operations

	lock
		local
			cipher_file: EL_ENCRYPTED_FILE; key_file: RAW_FILE; i, byte_count: INTEGER
		do
			if not secure_path.exists then
				if not credential.is_phrase_set then
					credential.ask_user
				end
				create cipher_file.make_open_write (secure_path, credential.new_aes_encrypter (256))
				cipher_file.put_data (File.data (key_path))
				cipher_file.close
			end
			byte_count := File.byte_count (key_path)
			-- Over write file
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
			cipher_file: EL_ENCRYPTED_FILE; key_file: RAW_FILE
		do
			if is_locked then
				credential.ask_user
				create cipher_file.make_open_read (secure_path, credential.new_aes_encrypter (256))
				create key_file.make_open_write (key_path)
				if attached cipher_file.plain_data as data then
					key_file.put_managed_pointer (data, 0, data.count)
					key_file.close
				end
				cipher_file.close
			end
		ensure
			unlocked: is_unlocked
		end

feature -- Basic operations

	remove_config
		do
			File_system.remove_file (file_path)
		end

feature {NONE} -- Internal attributes

	credential: EL_BUILDABLE_AES_CREDENTIAL

	key_path: FILE_PATH

	secure_path: FILE_PATH

feature {NONE} -- Constants

	Extension: TUPLE [secure, xml: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "secure, xml")
		end

	Transient_fields: STRING
		once
			Result := Precursor + ", key_path, secure_path"
		end
end