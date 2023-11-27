note
	description: "AES encryption using cipher chain blocks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 18:54:24 GMT (Monday 27th November 2023)"
	revision: "22"

class
	EL_AES_ENCRYPTER

inherit
	EL_AES_CONSTANTS
		export
			{ANY} all
		undefine
			default_create, out
		end

	EL_MODULE_BASE_64; EL_MODULE_DIGEST

	EL_STRING_GENERAL_ROUTINES

create
	default_create, make, make_from_key, make_from_other

feature {NONE} -- Initialization

	default_create
		do
			make_from_key (new_block)
		ensure then
			is_default: is_default
		end

	make (pass_phrase: READABLE_STRING_GENERAL; key_size_bits: INTEGER)
			--
		require
			valid_key_size: valid_key_bit_count (key_size_bits)
		local
			size_bytes: INTEGER
		do
			key_data := Digest.sha_256 (as_zstring (pass_phrase).to_utf_8)
			size_bytes := key_size_bits // 8
			if size_bytes < key_data.count then
				key_data.keep_head (size_bytes)
			end
			make_from_key (key_data)
		end

	make_from_key (a_key_data: like new_block)
			--
		require
			valid_key_size: valid_key_byte_count (a_key_data.count)
		local
			i: INTEGER; initial: SPECIAL [NATURAL_8]
		do
			key_data := a_key_data
			create initial.make_empty (Block_size)
			from i := 0 until i = initial.capacity loop
				initial.extend (i.to_natural_8)
				i := i + 1
			end
			block := [initial, new_block, new_block]
			create aes_key.make (key_data)
			reset
		end

	make_from_other (other: like Current)
		do
			make_from_key (other.key_data)
		end

feature -- Access

	key_size: INTEGER
		do
			Result := key_data.count
		end

	new_duplicate: like Current
		-- duplicate of current in default state
		do
			create Result.make_from_key (key_data)
		ensure
			in_default_state: Result.is_default_state
		end

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

	encrypted_size (byte_count: INTEGER): INTEGER
		do
			Result := (byte_count / Block_size).ceiling * Block_size
		end

feature -- Access attributes

	key_data: like new_block

feature -- Status setting

	reset
			-- reset chain block to initial block
		do
			encryption := new_encryption
			decryption := new_decryption
		end

feature -- Status query

	is_default: BOOLEAN
		-- `True' if created with `default_create'
		do
			if key_data.count = Block_size and then key_data.filled_with (0, 0, Block_size - 1) then
				Result := True
			end
		end

	is_default_state: BOOLEAN
		do
			Result := encryption ~ new_encryption and then decryption ~ new_decryption
		end

feature -- File operations

	restore_encryption_state (file: RAW_FILE)
		local
			data: MANAGED_POINTER; l_block: ARRAY [NATURAL_8]
		do
--			log.enter ("restore_encryption_state")
			create data.make (Block_size)
			file.read_to_managed_pointer (data, 0, data.count)
			l_block := data.read_array (0, data.count)
			encryption.make (aes_key, l_block, 0)
--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

	save_encryption_state (file: RAW_FILE)
		local
			data: MANAGED_POINTER; l_block: ARRAY [NATURAL_8]
		do
--			log.enter ("save_encryption_state")
			create l_block.make_from_special (encryption.last_block)
			create data.make_from_array (l_block)
			file.put_managed_pointer (data, 0, data.count)
--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

feature -- Encryption

	base_64_encrypted (plain_text: STRING): STRING
			--
		local
			padded_plain_data: EL_PADDED_BYTE_ARRAY
		do
			create padded_plain_data.make_from_string (plain_text, Block_size)
			Result := Base_64.encoded_special (encrypted (padded_plain_data), False)
		end

	encrypted (plain_data: EL_PADDED_BYTE_ARRAY): EL_BYTE_ARRAY
			--
		require
			is_16_byte_blocks: plain_data.count \\ Block_size = 0
		local
			i, block_count, offset: INTEGER
			block_out: like new_block
		do
			block_out := block.output
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

	decrypted_base_64 (cipher_text: STRING): STRING
			-- decrypt base 64 encoded string
		local
			cipher_data: EL_BYTE_ARRAY
		do
			if cipher_text.is_empty then
				create Result.make_empty
			else
				cipher_data := Base_64.decoded_special (cipher_text)
				Result := padded_decrypted (cipher_data).to_unpadded_string
			end
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
			block_out, block_in: like new_block
		do
			block_in := block.input; block_out := block.output
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

feature {NONE} -- Factory

	new_block: SPECIAL [NATURAL_8]
		do
			create Result.make_filled (0, Block_size)
		end

	new_decryption: EL_CBC_DECRYPTION
		do
			create Result.make (aes_key, block.initial, 0)
		end

	new_encryption: EL_CBC_ENCRYPTION
		do
			create Result.make (aes_key, block.initial, 0)
		end

feature {EL_ENCRYPTABLE} -- Implementation: attributes

	aes_key: AES_KEY

	block: TUPLE [initial, input, output: like new_block]

	decryption: EL_CBC_DECRYPTION

	encryption: EL_CBC_ENCRYPTION

end