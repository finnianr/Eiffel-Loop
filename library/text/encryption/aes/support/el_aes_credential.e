note
	description: "Validate pass phrases for AES encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-28 17:28:34 GMT (Tuesday 28th November 2023)"
	revision: "27"

class
	EL_AES_CREDENTIAL

inherit
	UUID_GENERATOR
		export
			{NONE} all
		end

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_AES_CONSTANTS
		export
			{ANY} valid_key_bit_count
		end

	EL_SHARED_DEFAULT_LISTENER

	EL_MODULE_BASE_64; EL_MODULE_DIGEST; EL_MODULE_ENCRYPTION

create
	make_valid, make

feature {NONE} -- Initialization

	make_valid (a_phrase: READABLE_STRING_GENERAL)
		do
			make
			force_validation (a_phrase)
		end

	make
		do
			Precursor
			create salt.make_empty (0)
			create target.make_filled (1, 32)
			create key_data.make_empty (0)
			on_validation := Default_listener
		end

feature -- Access

	digest_base_64: STRING
		-- pass phrase authentication digest
		do
			Result := Base_64.encoded_special (target, False)
		end

	salt_base_64: STRING
		do
			Result := Base_64.encoded_special (salt, False)
		end

feature -- Basic operations

	display (log: EL_LOGGABLE)
		do
			log.put_labeled_string ("Salt", salt_base_64)
			log.put_new_line
			log.put_labeled_string ("Digest", digest_base_64)
			log.put_new_line
			log.put_labeled_string ("Is valid", is_valid.out)
			log.put_new_line
		end

feature -- Element change

	force_validation (a_phrase: READABLE_STRING_GENERAL)
		do
			if attached Encryption.new_utf_8_phrase (a_phrase) as phrase_utf_8 then
				set_random_salt
				target := new_salted (phrase_utf_8)
				key_data := Digest.sha_256 (phrase_utf_8)
				on_validation.notify
				phrase_utf_8.fill_blank
			end
		ensure
			validated: is_valid
			restorable: new_restored_credential (a_phrase).is_valid
		end

	set_from_other (other: EL_AES_CREDENTIAL)
		do
			salt := other.salt; target := other.target; key_data := other.key_data
		end

	set_salt (a_salt_base_64: STRING)
		do
			salt := Base_64.decoded_special (a_salt_base_64)
		end

	set_target (a_digest_base_64: STRING)
		do
			target := Base_64.decoded_special (a_digest_base_64)
		end

	set_validation_action (action: PROCEDURE)
		do
			create {EL_AGENT_EVENT_LISTENER} on_validation.make (action)
		end

	set_validation_listener (listener: EL_EVENT_LISTENER)
		do
			on_validation := listener
		end

	try_validating (a_phrase: READABLE_STRING_GENERAL)
		require
			salt_is_set: is_salt_set
		do
			if attached Encryption.new_utf_8_phrase (a_phrase) as phrase_utf_8 then
				if target ~ new_salted (phrase_utf_8) then
					key_data := Digest.sha_256 (phrase_utf_8)
					on_validation.notify
				end
				phrase_utf_8.fill_blank
			end
		ensure
			restorable: is_valid implies new_restored_credential (a_phrase).is_valid
		end

feature -- Status query

	is_salt_set: BOOLEAN
		do
			Result := salt.count = Salt_count
		end

	is_valid: BOOLEAN
		do
			Result := key_data.count > 0
		end

feature -- Factory

	new_aes_encrypter (bit_count: INTEGER): EL_AES_ENCRYPTER
		require
			valid_pass_phrase: is_valid
			valid_bit_count: valid_key_bit_count (bit_count)
		do
			create Result.make_sized (key_data, bit_count)
		end

	new_restored_credential (a_phrase: READABLE_STRING_GENERAL): EL_AES_CREDENTIAL
		-- contract support
		do
			create Result.make
			Result.set_target (digest_base_64)
			Result.set_salt (salt_base_64)
			Result.try_validating (a_phrase)
		end

feature {NONE} -- Implementation

	new_salted (phrase_utf_8: STRING_8): like target
		local
			md5: MD5; sha: SHA256
			md5_hash, data, phrase_data: like target
			i, j: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create sha.make
			create Result.make_filled (1, 32)
			create md5.make
			create md5_hash.make_filled (1, 16)
			phrase_data := s.to_code_array (phrase_utf_8)
			from i := 0 until i > 50 loop
				if i \\ 2 = 0 then
					data := phrase_data
				else
					data := salt
				end
				if data.count > 0 then
					j := i \\ data.count
					if data [j] \\ 2 = 0 then
						md5.sink_special (data, 0, data.count - 1)
					else
						sha.sink_special (data, 0, data.count - 1)
					end
				end
				i := i + 1
			end
			sha.do_final (Result, 0)
			md5.do_final (md5_hash, 0)
			-- Merge hashes
			from i := 0 until i = md5_hash.count loop
				Result [i * 2] := Result.item (i * 2).bit_xor (md5_hash [i])
				i := i + 1
			end
		end

	set_random_salt
		local
			i: INTEGER
		do
			create salt.make_empty (Salt_count)
			from i := 0 until i = salt.capacity loop
				salt.extend (rand_byte)
				i := i + 1
			end
		end

feature {EL_AES_CREDENTIAL} -- Internal attributes

	key_data: SPECIAL [NATURAL_8]
		-- key data for AES encrypter from validated pass phrase

	on_validation: EL_EVENT_LISTENER

	salt: like target

	target: SPECIAL [NATURAL_8]
		-- target digest for validation

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["digest", agent digest_base_64],
				["salt",	  agent salt_base_64]
			>>)
		end

feature {NONE} -- Constants

	Salt_count: INTEGER = 24

end