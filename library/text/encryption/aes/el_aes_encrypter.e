note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_AES_ENCRYPTER

inherit
	EL_MODULE_BASE_64
		redefine
			default_create, out
		end

	EL_MODULE_ENCRYPTION
		rename
			Encryption as Mod_encryption
		undefine
			default_create, out
		end

	EL_MODULE_LOG
		undefine
			default_create, out
		end

create
	default_create, make_from_key, make_256, make_192, make_128

feature {NONE} -- Initialization

	default_create
		do
			make_from_key (create {ARRAY [NATURAL_8]}.make (1, 16))
		end

	make_256 (pass_phrase: EL_ASTRING)
			--
		do
			make (pass_phrase, 256)
		end

	make_192 (pass_phrase: EL_ASTRING)
			--
		do
			make (pass_phrase, 192)
		end

	make_128 (pass_phrase: EL_ASTRING)
			--
		do
			make (pass_phrase, 128)
		end

	make (pass_phrase: EL_ASTRING; key_size_bits: INTEGER)
			--
		require
			valid_key_size: (<< 128, 192, 256 >>).has (key_size_bits)
		local
			size_bytes: INTEGER
		do
			key_data := Mod_encryption.sha256_digest_32 (pass_phrase.to_utf8)

			size_bytes := key_size_bits // 8
			if size_bytes < key_data.count then
				key_data := key_data.subarray (1, size_bytes)
			end

			make_from_key (key_data)
		end

	make_from_key (a_key_data: ARRAY [NATURAL_8])
			--
		require
			valid_key_size: (<< 16, 24, 32 >>).has (a_key_data.count)
		local
			i: INTEGER
		do
			key_data := a_key_data
			create initial_block.make_empty (Block_size)
			from i := 0 until i = initial_block.capacity loop
				initial_block.extend (i.to_natural_8)
				i := i + 1
			end
			create aes_key.make (key_data)
			reset
		end

feature -- Status setting

	reset
			-- reset chain block to initial block
		do
			create encryption.make (aes_key, initial_block, 0)
			create decryption.make (aes_key, initial_block, 0)
		end

	set_encrypter_state (a_initial_block: SPECIAL [NATURAL_8])
		do
			encryption.make (aes_key, a_initial_block, 0)
		end

feature -- Access

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (key_data.count * 5 + 6)
			Result.append ("<< ")
			from i := 1 until i > key_data.count loop
				if i > 1 then
					Result.append (", ")
				end
				Result.append_integer (key_data [i])
				i := i + 1
			end
			Result.append (" >>")
		end

	key_data: ARRAY [NATURAL_8]

feature -- Encryption

	base64_encrypted (plain_text: STRING): STRING
			--
		local
			padded_plain_data: EL_PADDED_BYTE_ARRAY
		do
			create padded_plain_data.make_from_string (plain_text, Block_size)
			Result := Base_64.encoded_special (encrypted (padded_plain_data))
		end

	encrypted_managed (managed: MANAGED_POINTER): EL_BYTE_ARRAY
			--
		local
			padded_plain_data: EL_PADDED_BYTE_ARRAY
		do
			log.enter ("encrypted_managed")
			create padded_plain_data.make_from_managed (managed, managed.count, Block_size)
			Result := encrypted (padded_plain_data)
			log.exit
		end

	encrypted (plain_data: EL_PADDED_BYTE_ARRAY): EL_BYTE_ARRAY
			--
		require
			is_16_byte_blocks: plain_data.count \\ Block_size = 0
		local
			i, block_count, offset: INTEGER
			block_out: like Out_block
		do
			block_out := Out_block
			create Result.make (plain_data.count)
			block_count := plain_data.count // Block_size
			from i := 0 until i = block_count loop
				offset := i * Block_size
				encryption.encrypt_block (plain_data.area, offset, block_out, 0)
				Result.area.copy_data (block_out, 0, offset, Block_size)
				i := i + 1
			end
		end

feature -- Decryption

	decrypted_base64 (base64_cipher_text: STRING): STRING
			-- decrypt base 64 encoded string
		local
			cipher_text: STRING
			cipher_data: EL_BYTE_ARRAY
		do
			cipher_text := Base_64.decoded (base64_cipher_text)
			create cipher_data.make_from_string (cipher_text)
			Result := padded_decrypted (cipher_data).to_unpadded_string
		end

	decrypted_managed (managed: MANAGED_POINTER): SPECIAL [NATURAL_8]
		require
			is_16_byte_blocks: managed.count \\ Block_size = 0
		local
			cipher_data: EL_BYTE_ARRAY
		do
			create cipher_data.make_from_managed (managed, managed.count)
			Result := padded_decrypted (cipher_data).unpadded
		end

	padded_decrypted (cipher_data: EL_BYTE_ARRAY): EL_PADDED_BYTE_ARRAY
			--
		require
			is_16_byte_blocks: cipher_data.count \\ Block_size = 0
		local
			i, block_count, offset: INTEGER
			block_out, block_in: like Out_block
		do
			block_out := Out_block
			block_in := In_block
			create Result.make (cipher_data.count, Block_size)

			block_count := cipher_data.count // Block_size
			from i := 0 until i = block_count loop
				offset := i * Block_size
				block_in.copy_data (cipher_data.area, offset, 0, Block_size)
				decryption.decrypt_block (block_in, 0, block_out, 0)
				Result.area.copy_data (block_out, 0, offset, Block_size)
				i := i + 1
			end
		end

feature {EL_ENCRYPTABLE} -- Implementation: attributes

	initial_block: SPECIAL [NATURAL_8]

	aes_key: AES_KEY

	encryption: EL_CBC_ENCRYPTION

	decryption: EL_CBC_DECRYPTION

feature -- Constants

	Block_size: INTEGER = 16

	In_block: SPECIAL [NATURAL_8]
		once
			create Result.make_filled (0, Block_size)
		end

	Out_block: SPECIAL [NATURAL_8]
		once
			create Result.make_filled (0, Block_size)
		end
end