note
	description: "Validate pass phrases for AES encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 18:20:37 GMT (Monday 27th November 2023)"
	revision: "26"

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

	EL_MODULE_BASE_64

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
			Result := Base_64.encoded_special (digest, False)
		end

	phrase: ZSTRING
		-- pass phrase

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

	set_digest (a_digest_base_64: STRING)
		do
			digest := Base_64.decoded_special (a_digest_base_64)
		end

	set_from_other (other: EL_AES_CREDENTIAL)
		do
			phrase := other.phrase
			salt := other.salt
			digest := other.digest
		end

	set_phrase (a_phrase: ZSTRING)
		do
			phrase := a_phrase
		end

	set_salt (a_salt_base_64: STRING)
		do
			salt := Base_64.decoded_special (a_salt_base_64)
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

	is_phrase_set: BOOLEAN
		do
			Result := phrase.count > 0
		end

	is_salt_set: BOOLEAN
		do
			Result := salt.count = Salt_count
		end

	is_valid: BOOLEAN
		do
			Result := is_salt_set and then digest ~ actual_digest
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

	actual_digest: like digest
		local
			md5: MD5; sha: SHA256
			md5_hash, data, phrase_data: like digest
			i, j: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create sha.make
			create Result.make_filled (1, 32)
			create md5.make
			create md5_hash.make_filled (1, 16)
			phrase_data := s.to_code_array (phrase.to_utf_8)
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

	digest: SPECIAL [NATURAL_8]

	salt: like digest

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