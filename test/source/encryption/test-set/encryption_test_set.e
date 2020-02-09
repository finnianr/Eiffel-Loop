note
	description: "Encryption test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-07 10:34:42 GMT (Friday 7th February 2020)"
	revision: "12"

class
	ENCRYPTION_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_OS

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
			create encrypter.make ("hanami", 256)
		end

feature -- Basic operations

	test_aes_encryption
			--
		do
			across OS.file_list ("encryption", "*.txt") as file_path loop
				encrypt (file_path.item)
			end
		end

feature {NONE} -- Implementation

	encrypt (file_path: EL_FILE_PATH)
			--
		local
			lines: PLAIN_TEXT_FILE; encrypted_lines: LINKED_LIST [STRING]
			i: INTEGER
		do
			encrypter.reset
			create encrypted_lines.make

			across 1 |..| 2 as n loop
				create lines.make_open_read (file_path)
				from i := 1; lines.read_line until lines.after loop
					if n.item = 1 then
						encrypted_lines.extend (encrypter.base64_encrypted (lines.last_string))
					else
						assert ("same text", lines.last_string ~ encrypter.decrypted_base64 (encrypted_lines [i]))
					end
					lines.read_line
					i := i + 1
				end
				lines.close
			end
		end

feature {NONE} -- Internal attributes

	encrypter: EL_AES_ENCRYPTER

end
