note
	description: "Encryption test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 7:25:30 GMT (Tuesday 20th June 2023)"
	revision: "20"

class
	ENCRYPTION_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		redefine
			make, on_prepare
		end

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["aes_encryption", agent test_aes_encryption],
				["secure_file",	 agent test_secure_file]
			>>)
		end

	on_prepare
		do
			Precursor
			create encrypter.make ("hanami", 256)
		end

feature -- Tests

	test_aes_encryption
			--
		do
			across new_file_list ("*.txt") as txt_path loop
				encrypt (txt_path.item)
			end
		end

	test_secure_file
		local
			key_file: EL_SECURE_KEY_FILE
			target_path: FILE_PATH
		do
			target_path := file_path ("words.txt")
			create key_file.make (target_path)
		end

feature {NONE} -- Implementation

	encrypt (target_path: FILE_PATH)
			--
		local
			lines: PLAIN_TEXT_FILE; encrypted_lines: LINKED_LIST [STRING]
			i: INTEGER
		do
			encrypter.reset
			create encrypted_lines.make

			across 1 |..| 2 as n loop
				create lines.make_open_read (target_path)
				from i := 1; lines.read_line until lines.after loop
					if n.item = 1 then
						encrypted_lines.extend (encrypter.base_64_encrypted (lines.last_string))
					else
						assert ("same text", lines.last_string ~ encrypter.decrypted_base_64 (encrypted_lines [i]))
					end
					lines.read_line
					i := i + 1
				end
				lines.close
			end
		end

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "encryption"
		end

feature {NONE} -- Internal attributes

	encrypter: EL_AES_ENCRYPTER

end