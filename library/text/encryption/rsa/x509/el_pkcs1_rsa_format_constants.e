note
	description: "[
		PKCS1 RSA Constants
			RSAPrivateKey ::= SEQUENCE {
			    version           Version,
			    modulus           INTEGER,  -- n
			    publicExponent    INTEGER,  -- e
			    privateExponent   INTEGER,  -- d
			    prime1            INTEGER,  -- p
			    prime2            INTEGER,  -- q
			    exponent1         INTEGER,  -- d mod (p-1)
			    exponent2         INTEGER,  -- d mod (q-1)
			    coefficient       INTEGER,  -- (inverse of q) mod p
			    otherPrimeInfos   OtherPrimeInfos OPTIONAL
			}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 21:18:56 GMT (Thursday 7th July 2016)"
	revision: "6"

class
	EL_PKCS1_RSA_FORMAT_CONSTANTS

feature -- Constants

	Var_modulus: ZSTRING
		-- n
		once
			Result := "modulus"
		end

	Var_public_exponent: ZSTRING
		-- e
		once
			Result := "publicExponent"
		end

	Var_private_exponent: ZSTRING
		-- d
		once
			Result := "privateExponent"
		end

	Var_prime1: ZSTRING
		-- p
		once
			Result := "prime1"
		end

	Var_prime2: ZSTRING
		-- q
		once
			Result := "prime2"
		end

	Var_exponent1: ZSTRING
		-- d mod (p-1)
		once
			Result := "exponent1"
		end

	Var_exponent2: ZSTRING
		-- d mod (q-1)
		once
			Result := "exponent2"
		end

	Var_coefficient: ZSTRING
		-- (inverse of q) mod p
		once
			Result := "coefficient"
		end

	Variable_names: ARRAY [ZSTRING]
		once
			Result := <<
				Var_modulus,
				Var_public_exponent, Var_private_exponent,
				Var_prime1, Var_prime2,
				Var_exponent1, Var_exponent2,
				Var_coefficient
			>>
			Result.compare_objects
		end

end