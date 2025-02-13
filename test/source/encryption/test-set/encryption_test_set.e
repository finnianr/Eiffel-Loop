note
	description: "Encryption test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-13 15:10:12 GMT (Thursday 13th February 2025)"
	revision: "24"

class
	ENCRYPTION_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		redefine
			on_prepare, on_clean
		end

	SHARED_DEV_ENVIRON; EL_SHARED_PASSPHRASE_TEXTS

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

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor
			create encrypter.make (Phrase, 256)
		end

	on_clean
		do
			Precursor
			User_input.wipe_out_preinputs
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
			key_file: EL_SECURE_KEY_FILE; key_path: FILE_PATH
			target_digest: STRING
		do
			key_path := file_path_abs ("words.txt")

			User_input.preinput_line (Text.secure_file_prompt #$ [key_path.base], Phrase)
			User_input.preinput_line (Text.enter_passphrase, Phrase)

			create key_file.make (key_path)

			key_file.unlock
			target_digest := Digest.md5_plain_text (key_path).to_base_64_string
			key_file.lock
			assert ("key_file gone", not key_path.exists)

			create key_file.make (key_path)
			key_file.unlock
			assert ("key_file recreated", key_path.exists)
			assert_same_digest (Plain_text, key_path, target_digest)
			key_file.lock
			assert ("key_file gone", not key_path.exists)

			key_file.remove_config
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

feature {NONE} -- Constants

	Phrase: STRING = "hanami"

end