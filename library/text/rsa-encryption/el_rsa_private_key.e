note
	description: "[
		RSA private key with attributes reflectively settable from PKCS1 standard names
		
			RSAPrivateKey ::= SEQUENCE {
			    version           Version,
			    modulus           INTEGER,
			    publicExponent    INTEGER,
			    privateExponent   INTEGER,
			    prime1            INTEGER,
			    prime2            INTEGER,
			    exponent1         INTEGER,
			    exponent2         INTEGER,
			    coefficient       INTEGER,
			    otherPrimeInfos   OtherPrimeInfos OPTIONAL
			}

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-12 14:38:02 GMT (Friday 12th February 2021)"
	revision: "9"

class
	EL_RSA_PRIVATE_KEY

inherit
	EL_REFLECTIVE_RSA_KEY
		rename
			read as read_from,
			write as write_to
		redefine
			make_default
		end

	EL_MODULE_X509_COMMAND

	EL_FILE_OPEN_ROUTINES

-- Cannot inherit because of invariant: p * q ~ n
--	RSA_PRIVATE_KEY
--		rename
--			n as modulus,
--			p as prime_1,
--			q as prime_2,
--			d as private_exponent,
--			e as public_exponent
--		end

create
	make, make_default, make_from_primes, make_from_map_list, make_from_stored,
	make_from_pkcs1, make_from_pkcs1_file, make_from_pkcs1_cert

feature {NONE} -- Initialization

	make (a_prime_1, a_prime_2, a_modulus, a_public_exponent: INTEGER_X)
		local
			phi: INTEGER_X
		do
			if not attached field_table then
				field_table := Meta_data_by_type.item (Current).field_table
			end
			prime_1 := a_prime_1
			prime_2 := a_prime_2
			modulus := a_modulus
			public_exponent := a_public_exponent
			phi := (prime_1 - prime_1.one) * (prime_2 - prime_2.one)
			private_exponent := public_exponent.inverse_value (phi)
		ensure
			is_valid:
		end

	make_default
		do
			make_from_primes (17, 19)
		end

	make_from_pkcs1_cert (cert_file_path: EL_FILE_PATH; phrase: ZSTRING)
		local
			reader: like X509_command.new_key_reader
		do
			reader := X509_command.new_key_reader (cert_file_path, phrase)
			reader.execute
			if reader.has_error then
				make_default
			else
				make_from_pkcs1 (reader.lines)
			end
		end

	make_from_pkcs1_file (pkcs1_file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		local
			line_source: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE
		do
			create line_source.make (pkcs1_file_path, encrypter)
			make_from_pkcs1 (line_source)
			line_source.close
		end

	make_from_primes (a_prime_1, a_prime_2: INTEGER_X)
		do
			make (a_prime_1, a_prime_2, a_prime_1 * a_prime_2, Default_exponent)
		end

	make_from_stored (file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		-- make from binary file created with `store' routine
		do
			make_default
			if attached open_raw (file_path, Read) as file then
				copy (new_reader (encrypter).read_item (file))
				file.close
			end
		end

feature -- Access

	modulus: INTEGER_X

	prime_1: INTEGER_X

	prime_2: INTEGER_X

	private_exponent: INTEGER_X

	public_exponent: INTEGER_X

feature -- Status query

	is_default: BOOLEAN
		do
			Result := Current ~ Default_key
		end

	is_valid: BOOLEAN
		do
			Result := prime_1 * prime_2 ~ modulus
		end

feature -- Basic operations

	decrypt (cipher: INTEGER_X): INTEGER_X
		require
			is_valid: is_valid
		do
			result := cipher.powm_value (private_exponent, modulus)
		end

	sign (message: INTEGER_X): INTEGER_X
		do
			result := decrypt (message)
		end

	store (output_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		-- store as binary encrypted file
		do
			if attached open_raw (output_path, Write) as file then
				new_writer (encrypter).write (Current, file)
				file.close
			end
		end

feature -- Access

	prime_1_base_64: STRING
			--
		do
			Result := Base_64.encoded_special (prime_1.as_bytes)
		end

	prime_2_base_64: STRING
			--
		do
			Result := Base_64.encoded_special (prime_2.as_bytes)
		end

feature {NONE} -- Factory

	new_writer, new_reader (encrypter: EL_AES_ENCRYPTER): ECD_ENCRYPTABLE_READER_WRITER [like Current]
		do
			create Result.make (encrypter)
		end

feature {NONE} -- Constants

	Default_key: EL_RSA_PRIVATE_KEY
		once
			create Result.make_default
		end

	Field_hash: NATURAL = 266688151

end