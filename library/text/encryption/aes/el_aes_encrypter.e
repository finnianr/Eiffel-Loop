note
	description: "AES encryption using cipher chain blocks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-01 11:14:40 GMT (Wednesday 1st November 2017)"
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

create
	default_create, make_from_key, make_256, make_192, make_128, make_from_other

feature {NONE} -- Initialization

	default_create
		do
			make_from_key (create {ARRAY [NATURAL_8]}.make_filled (0, 1, 16))
		end

	make (pass_phrase: ZSTRING; key_size_bits: INTEGER)
			--
		require
			valid_key_size: (<< 128, 192, 256 >>).has (key_size_bits)
		local
			size_bytes: INTEGER
		do
			key_data := Mod_encryption.sha256_digest_32 (pass_phrase.to_utf_8)

			size_bytes := key_size_bits // 8
			if size_bytes < key_data.count then
				key_data.keep_head (size_bytes)
			end
			make_from_key (key_data)
		end

	make_128 (pass_phrase: ZSTRING)
			--
		do
			make (pass_phrase, 128)
		end

	make_192 (pass_phrase: ZSTRING)
			--
		do
			make (pass_phrase, 192)
		end

	make_256 (pass_phrase: ZSTRING)
			--
		do
			make (pass_phrase, 256)
		end

	make_from_key (a_key_data: like key_data)
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

	make_from_other (other: like Current)
		do
			make_from_key (other.key_data)
		end

feature -- Access

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (key_data.count * 5 + 6)
			Result.append ("<< ")
			from i := 0 until i = key_data.count loop
				if i > 0 then
					Result.append (", ")
				end
				Result.append_integer (key_data [i])
				i := i + 1
			end
			Result.append (" >>")
		end

feature -- Access attributes

	key_data: SPECIAL [NATURAL_8]

feature -- Status setting

	reset
			-- reset chain block to initial block
		do
			create encryption.make (aes_key, initial_block, 0)
			create decryption.make (aes_key, initial_block, 0)
		end

feature -- Status query

	is_default_state: BOOLEAN
		do
			Result := across key_data as component all component.item = 0 end
		end

feature -- File operations

	save_encryption_state (file: RAW_FILE)
		local
			data: MANAGED_POINTER; block: ARRAY [NATURAL_8]
		do
--			log.enter ("save_encryption_state")
			create block.make_from_special (encryption.last_block)
			create data.make_from_array (block)
			file.put_managed_pointer (data, 0, data.count)
--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

	restore_encryption_state (file: RAW_FILE)
		local
			data: MANAGED_POINTER; block: ARRAY [NATURAL_8]
		do
--			log.enter ("restore_encryption_state")
			create data.make (Block_size)
			file.read_to_managed_pointer (data, 0, data.count)
			block := data.read_array (0, data.count)
			encryption.make (aes_key, block, 0)
--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

feature -- Encryption

	base64_encrypted (plain_text: STRING): STRING
			--
		local
			padded_plain_data: EL_PADDED_BYTE_ARRAY
		do
			create padded_plain_data.make_from_string (plain_text, Block_size)
			Result := Base_64.encoded_special (encrypted (padded_plain_data))
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

	encrypted_managed (managed: MANAGED_POINTER; count: INTEGER): EL_BYTE_ARRAY
			--
		local
			padded_plain_data: EL_PADDED_BYTE_ARRAY
		do
			create padded_plain_data.make_from_managed (managed, count, Block_size)
			Result := encrypted (padded_plain_data)
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

	decrypted_managed (managed: MANAGED_POINTER; count: INTEGER): SPECIAL [NATURAL_8]
		require
			managed_big_enough: count <= managed.count
			count_multiple_of_block_size: count \\ Block_size = 0
		local
			cipher_data: EL_BYTE_ARRAY
		do
			create cipher_data.make_from_managed (managed, count)
			Result := padded_decrypted (cipher_data).unpadded
		end

	padded_decrypted (cipher_data: EL_BYTE_ARRAY): EL_PADDED_BYTE_ARRAY
			--
		require
			count_multiple_of_block_size: cipher_data.count \\ Block_size = 0
		local
			i, block_count, offset: INTEGER
			block_out, block_in: like Out_block
		do
			block_in := In_block; block_out := Out_block
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

	aes_key: AES_KEY

	decryption: EL_CBC_DECRYPTION

	encryption: EL_CBC_ENCRYPTION

	initial_block: SPECIAL [NATURAL_8]

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
