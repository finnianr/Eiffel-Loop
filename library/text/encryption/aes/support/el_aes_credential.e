note
	description: "Validate pass phrases for AES encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-09 13:52:49 GMT (Friday 9th October 2020)"
	revision: "14"

class
	EL_AES_CREDENTIAL

inherit
	UUID_GENERATOR
		export
			{NONE} all
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_AES_CONSTANTS
		export
			{ANY} valid_key_bit_count
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_USER_INPUT

	EL_MODULE_LIO

	EL_MODULE_STRING_8

	EL_MODULE_BASE_64

	EL_SHARED_PASSPHRASE_ATTRIBUTE

create
	make, make_default

feature {NONE} -- Initialization

	make (a_phrase: like phrase)
		do
			make_default
			set_phrase (a_phrase)
			validate
		end

	make_default
		do
			Precursor
			create phrase.make_empty
			create salt.make_empty (0)
			create digest.make_filled (1, 32)
		end

feature -- Access

	digest_base_64: STRING
		-- pass phrase authentication digest
		do
			Result := base_64.encoded_special (digest)
		end

	salt_base_64: STRING
		do
			Result := base_64.encoded_special (salt)
		end

	phrase: ZSTRING
		-- pass phrase

feature -- Element change

	ask_user
		local
			done: BOOLEAN
		do
			from  until done loop
				phrase := User_input.line (User_prompt)
				lio.put_new_line
				if is_salt_set then
					if is_valid then
						done := True
					else
						lio.put_line (Invalid_pass_phrase)
					end
				else
					validate
					done := True
				end
			end
		end

	set_from_other (other: EL_AES_CREDENTIAL)
		do
			phrase := other.phrase
			salt := other.salt
			digest := other.digest
		end

	set_phrase (a_phrase: like phrase)
		do
			phrase := a_phrase
		end

	set_salt (a_salt_base_64: STRING)
		do
			salt := Base_64.decoded_array (a_salt_base_64)
		end

	set_digest (a_digest_base_64: STRING)
		do
			digest := Base_64.decoded_array (a_digest_base_64)
		end

	validate
		-- set `salt' and `digest'
		require
			phrase_set: is_phrase_set
		do
			set_random_salt
			digest := actual_digest
		ensure
			is_valid: is_valid
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := is_salt_set and then digest ~ actual_digest
		end

	is_salt_set: BOOLEAN
		do
			Result := salt.count = Salt_count
		end

	is_phrase_set: BOOLEAN
		do
			Result := phrase.count > 0
		end

feature -- Factory

	new_aes_encrypter (bit_count: INTEGER): EL_AES_ENCRYPTER
		require
			valid_pass_phrase: is_valid
			valid_bit_count: valid_key_bit_count (bit_count)
		do
			create Result.make (phrase, bit_count)
		end

feature {NONE} -- Implementation

	actual_digest: like salt
		local
			md5: MD5; sha: SHA256
			md5_hash, data, phrase_data: like salt
			i, j: INTEGER
		do
			create sha.make
			create Result.make_filled (1, 32)
			create md5.make
			create md5_hash.make_filled (1, 16)
			phrase_data := String_8.to_code_array (phrase.to_utf_8)
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

	salt: SPECIAL [NATURAL_8]

	digest: like salt

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["digest", 	agent digest_base_64],
				["salt", 	agent salt_base_64]
			>>)
		end

feature {NONE} -- Constants

	Salt_count: INTEGER = 24

	Invalid_pass_phrase: ZSTRING
		once
			Result := Locale * "Pass phrase is invalid"
		end

	User_prompt: ZSTRING
		once
			Result := Locale * "Enter pass phrase"
		end

end