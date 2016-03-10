note
	description: "Summary description for {EL_RSA_PUBLIC_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 6:30:17 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_STORABLE_RSA_PUBLIC_KEY

inherit
	EL_RSA_PUBLIC_KEY
		redefine
			make_with_exponent
		end

	EL_STORABLE_RSA_KEY

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		redefine
			getter_function_table, Template, make_from_file
		end

create
	make, make_from_file, make_from_array, make_with_exponent

feature {NONE} -- Initialization

	make_from_file (file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			Precursor (file_path)
			create root_node.make_from_file (file_path)
			make (rsa_value (root_node, ""))
		end

	make_with_exponent (modulus_a: INTEGER_X exponent_a: INTEGER_X)
		do
			Precursor (modulus_a, exponent_a)
			make_serializeable
		end


feature {NONE} -- Evolicity fields

	get_value: STRING
			--
		local
			byte_array, modulus_byte_array: SPECIAL [NATURAL_8]
		do
			modulus_byte_array := modulus.as_bytes
			Result := Base_64.encoded_special (modulus_byte_array)
			byte_array := Base_64.decoded_array (Result)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["value", agent get_value]
			>>)
		end

feature {NONE} -- Implementation

	Value_xpath: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			create Result.make ("/rsa-public/value")
		end

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<rsa-public>
			<value>$value</value>
		</rsa-public>
	]"

end
