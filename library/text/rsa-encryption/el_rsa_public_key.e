note
	description: "Reflectively createable RSA public key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-26 11:29:49 GMT (Monday 26th July 2021)"
	revision: "13"

class
	EL_RSA_PUBLIC_KEY

inherit
	RSA_PUBLIC_KEY
		rename
			make as make_with_exponent
		undefine
			is_equal
		end

	EL_REFLECTIVE_RSA_KEY
		rename
			make_default as make_reflective
		end

	EL_MODULE_BASE_64

	EL_MODULE_RSA

	EL_MODULE_X509

create
	make, make_from_array, make_from_base_64, make_from_manifest, make_from_pkcs1_table

feature {NONE} -- Initialization

	make (a_modulus: INTEGER_X)
			--
		do
			make_reflective
			make_with_exponent (a_modulus, Default_exponent)
		end

	make_default
		do
			make (2)
		end

	make_from_array (a_modulus: SPECIAL [NATURAL_8])
			--
		do
			make (Rsa.integer_x_from_array (a_modulus))
		end

	make_from_base_64 (base_64_modulus: STRING)
			--
		do
			make_from_array (Base_64.decoded_special (base_64_modulus))
		end

	make_from_manifest (a_modulus: ARRAY [INTEGER])
		-- use to intialize from manifest containing factorized digits multiplied back together
		-- This form should make it more difficult for pirates to alter the machine code of executable
		local
			l_area: SPECIAL [NATURAL_8]
		do
			create l_area.make_filled (0, a_modulus.count)
			across a_modulus as n loop
				l_area [n.cursor_index - 1] := n.item.to_natural_8
			end
			make (Rsa.integer_x_from_array (l_area))
		end

feature -- Basic operations

	encrypt_base_64 (base64_message: STRING): INTEGER_X
			--
		local
			message: INTEGER_X
		do
			message := Rsa.integer_x_from_base_64 (base64_message)
			Result := encrypt (message)
		end

	verify_base_64 (message: INTEGER_X; base64_signature: STRING): BOOLEAN
			--
		do
			Result := verify (message, Rsa.integer_x_from_base_64 (base64_signature))
		end

feature -- Access

	decrypted_string (cipher_message: INTEGER_X; count: INTEGER): STRING
		-- convert signed `cipher_message' to string with `count' character
		local
			plain_message: INTEGER_X; plain_data: ARRAY [NATURAL_8]
		do
			-- counterintutive but correct, `encrypt' reverses signing with private key
			plain_message := encrypt (cipher_message)
			create Result.make (count)

			-- check precondition for `to_fixed_width_byte_array'
			if count - plain_message.bytes >= 0 then
				create plain_data.make_from_special (plain_message.as_fixed_width_byte_array (count))
				across plain_data as byte until byte.item = 0 loop
					Result.append_character (byte.item.to_character_8)
				end
			end
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 1181435192

end