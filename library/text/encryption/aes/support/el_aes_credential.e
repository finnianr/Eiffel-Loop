note
	description: "[
		Localizeable class for assessing, entering and validating pass phrases for AES encryption
		
		See file: `localization/el_pass_phrase.pyx'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-11 8:40:56 GMT (Monday 11th December 2017)"
	revision: "5"

class
	EL_AES_CREDENTIAL

inherit
	EL_MODULE_BASE_64

	UUID_GENERATOR
		export
			{NONE} all
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_USER_INPUT

	EL_MODULE_LIO

	EL_MODULE_STRING_8

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
			salt := Default_salt
			create digest.make_filled (1, 32)
		end

feature -- Access

	digest_base_64: STRING
			-- pass phrase authentication digest
		do
			Result := base_64.encoded_special (digest)
		end

	password_strength: ZSTRING
		do
			Result := Locale * Eng_password_strengths [security_score]
		end

	salt_base_64: STRING
		do
			Result := base_64.encoded_special (salt)
		end

	security_description: ZSTRING
			--
		do
			if security_score > 0 then
				Result := Security_description_template.substituted_tuple ([password_strength, security_score])
			else
				create Result.make_empty
			end
		end

	security_score: INTEGER
		local
			i, upper_count, lower_count, numeric_count, other_count: INTEGER
			c: CHARACTER_32
		do
			from i := 1 until i > phrase.count loop
				c := phrase.unicode_item (i)
				if c.is_digit then
					numeric_count := numeric_count + 1

				elseif c.is_alpha then
					if c.is_upper then
						upper_count := upper_count + 1
					else
						lower_count := lower_count + 1
					end

				else
					other_count := other_count + 1

				end
				i := i + 1
			end
			Result := Result + upper_count.min (1)
			Result := Result + lower_count.min (1)
			Result := Result + numeric_count.min (1)
			Result := Result + other_count.min (1)

			from i := 1 until i > Password_count_levels.count loop
				if phrase.count >= Password_count_levels [i] then
					Result := Result + 1
				end
				i := i + 1
			end
			Result := Result.min (Eng_password_strengths.count)
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
			Result := salt /= Default_salt
		end

feature -- Factory

	new_aes_encrypter (bit_count: NATURAL): EL_AES_ENCRYPTER
		require
			valid_pass_phrase: is_valid
		do
			inspect bit_count
				when 256 then
					create Result.make_256 (phrase)
				when 192 then
					create Result.make_192 (phrase)
			else
				create Result.make_128 (phrase)
			end
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
			create salt.make_empty (Default_salt.count)
			from i := 0 until i = salt.capacity loop
				salt.extend (rand_byte)
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

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

	Default_salt: SPECIAL [NATURAL_8]
		once ("PROCESS")
			create Result.make_filled (0, 24)
		end

	Invalid_pass_phrase: ZSTRING
		once
			Result := Locale * "Pass phrase is invalid"
		end

	User_prompt: ZSTRING
		once
			Result := Locale * "Enter pass phrase"
		end

	Eng_password_strengths: ARRAY [STRING]
			--
		once
			create Result.make (1, 9)
			Result [1] := "is absolutely terrible"
			Result [2] := "is very poor"
			Result [3] := "is poor"
			Result [4] := "is below average"
			Result [5] := "is average"
			Result [6] := "is above average"
			Result [7] := "is good"
			Result [8] := "is very good"
			Result [9] := "is excellent"
		end

	Password_count_levels: ARRAY [INTEGER]
			--
		once
			Result := << 8, 10, 12, 14, 16, 18 >>
		end

	Security_description_template: ZSTRING
		once
			Locale.set_next_translation ("Passphrase strength %S (%S)")
			Result := Locale * "{security-description-template}"
		end

end
