note
	description: "[
		${GROUPED_ECF_LINES} for **custom** condition tag
	]
	notes: "[	
		Shorthand:
		
			condition:
				x = y
				
		Expansion:
		
			condition:
				custom:
					name = x; value = y
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-06 17:42:44 GMT (Saturday 6th April 2024)"
	revision: "7"

class
	CUSTOM_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			set_variables, Template
		end

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.custom
		end

feature {NONE} -- Implementation

	set_variables (nvp: ECF_NAME_VALUE_PAIR)
		do
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				custom:
					name = $NAME; value = $VALUE
			]"
		end

end