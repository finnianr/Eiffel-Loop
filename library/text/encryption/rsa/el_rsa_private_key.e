note
	description: "Summary description for {EL_RSA_PRIVATE_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_RSA_PRIVATE_KEY

inherit
	RSA_PRIVATE_KEY

	EL_RSA_KEY

	EL_MODULE_BASE_64

	EL_PKCS1_RSA_FORMAT_CONSTANTS

create
	make, make_from_primes, make_from_pkcs1

feature {NONE} -- Initialization

	make_from_primes (a_p, a_q: INTEGER_X)
		do
			make (a_p, a_q, a_p * a_q, Default_exponent)
		end

	make_from_pkcs1 (pkcs1_values: HASH_TABLE [INTEGER_X, STRING])
		do
			n := pkcs1_values [Var_modulus]
			p := pkcs1_values [Var_prime1]
			q := pkcs1_values [Var_prime2]
			d := pkcs1_values [Var_private_exponent]
			e := pkcs1_values [Var_public_exponent]
		end

feature -- Access

	p_base_64: STRING
			--
		do
			Result := Base_64.encoded_special (p.as_bytes)
		end

	q_base_64: STRING
			--
		do
			Result := Base_64.encoded_special (q.as_bytes)
		end

end
