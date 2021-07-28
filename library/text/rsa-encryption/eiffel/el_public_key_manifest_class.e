note
	description: "Public key manifest class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-28 17:23:52 GMT (Wednesday 28th July 2021)"
	revision: "2"

class
	EL_PUBLIC_KEY_MANIFEST_CLASS

inherit
	EL_SIGNED_EIFFEL_CLASS
		redefine
			getter_function_table, field_list, Template
		end

create
	make

feature -- Access

	field_list: EL_ARRAYED_LIST [EL_PUBLIC_KEY_FIELD]

feature {NONE} -- Implementation

	getter_function_table: like getter_functions
		require else
			has_first: field_list.count > 0
		do
			Result := Precursor +
				["key_field", agent: EL_PUBLIC_KEY_FIELD do Result := field_list.first end]
		end

feature {NONE} -- Constants

	Template: STRING = "[
		class
			$name

		feature {NONE} -- Constants

			$key_field.name: EL_RSA_PUBLIC_KEY
				-- X509 public key serial number: $serial_number
				once ("PROCESS")
					create Result.make_from_manifest (<<
					#across $key_field.data_lines as $line loop
						$line.item
					#end
					>>)
				end

		end
	]"
end