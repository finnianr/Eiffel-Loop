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
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-30 13:01:21 GMT (Friday 30th March 2018)"
	revision: "3"

class
	EL_RSA_PRIVATE_KEY

inherit
	RSA_PRIVATE_KEY
		rename
			n as modulus,
			p as prime_1,
			q as prime_2,
			d as private_exponent,
			e as public_exponent
		end

	EL_REFLECTIVE_RSA_KEY

create
	make, make_default, make_from_primes, make_from_map_list, make_from_pkcs1, make_from_pkcs1_file

feature {NONE} -- Initialization

	make_from_primes (a_prime_1, a_prime_2: INTEGER_X)
		do
			make (a_prime_1, a_prime_2, a_prime_1 * a_prime_2, Default_exponent)
		end

	make_default
		do
			make_from_primes (17, 19)
		end

	make_from_pkcs1_file (pkcs1_file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		local
			line_source: EL_ENCRYPTED_FILE_LINE_SOURCE
		do
			create line_source.make (pkcs1_file_path, encrypter)
			make_from_pkcs1 (line_source)
			line_source.close
		end

	make_from_pkcs1 (lines: LINEAR [ZSTRING])
		do
			make_from_map_list (RSA.pkcs1_map_list (lines))
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

end
