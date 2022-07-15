note
	description: "[
		[$source GROUPED_ECF_LINES] for **custom** condition tag
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-15 10:53:24 GMT (Friday 15th July 2022)"
	revision: "1"

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

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
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