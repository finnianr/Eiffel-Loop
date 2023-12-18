note
	description: "Validate pass phrases for AES encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-18 8:01:00 GMT (Monday 18th December 2023)"
	revision: "29"

class
	EL_AES_CREDENTIAL

inherit
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
			create salt.make_empty (0)
			create target.make_filled (1, 32)
			create key_data.make_empty (0)
			on_validation := Default_listener
		end

feature -- Access

	target_base_64: STRING
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
			log.put_field_list (100, <<
				["Salt", salt_base_64], ["Target digest", target_base_64], ["Is valid", is_valid.out]
			>>)
			log.put_new_line
		end

feature -- Element change

	force_validation (a_phrase: READABLE_STRING_GENERAL)
		do
			if attached Encryption.new_utf_8_phrase (a_phrase) as phrase_utf_8 then
				salt := Digest.new_random_salt
				target := Digest.new_salted (phrase_utf_8, salt)
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
				if target ~ Digest.new_salted (phrase_utf_8, salt) then
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
			Result := salt.count = Digest.Salt_count
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
			Result.set_target (target_base_64)
			Result.set_salt (salt_base_64)
			Result.try_validating (a_phrase)
		end

feature {EL_AES_CREDENTIAL} -- Internal attributes

	key_data: SPECIAL [NATURAL_8]
		-- key data for AES encrypter from validated pass phrase

	on_validation: EL_EVENT_LISTENER

	salt: like target

	target: SPECIAL [NATURAL_8]
		-- target digest for validation

end