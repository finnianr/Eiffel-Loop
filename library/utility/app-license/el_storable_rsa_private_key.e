note
	description: "Summary description for {EL_RSA_PRIVATE_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 6:30:06 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_STORABLE_RSA_PRIVATE_KEY

inherit
	EL_RSA_PRIVATE_KEY
		redefine
			make
		end

	EL_STORABLE_RSA_KEY

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		redefine
			getter_function_table, Template, make_from_file
		end

create
	make, make_from_file

feature {NONE} -- Initialization

	make_from_file (file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			Precursor (file_path)
			create root_node.make_from_file (file_path)
			make_from_primes (rsa_value (root_node, "p"), rsa_value (root_node, "q"))
		end

	make (p_a: INTEGER_X q_a: INTEGER_X n_a: INTEGER_X e_a: INTEGER_X)
			--
		do
			Precursor (p_a, q_a, n_a, e_a)
			make_serializeable
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["p", agent p_base_64],
				["q", agent q_base_64]
			>>)
		end

feature {NONE} -- Implementation

	Value_xpath: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			create Result.make ("/rsa-private/value[@id='$id']")
		end

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<rsa-private>
			<value id="p">$p</value>
			<value id="q">$q</value>
		</rsa-private>
	]"

end
