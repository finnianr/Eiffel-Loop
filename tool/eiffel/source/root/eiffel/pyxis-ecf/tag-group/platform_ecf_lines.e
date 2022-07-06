note
	description: "[
		[$source GROUPED_ECF_LINES] for **platform** condition tag
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 15:00:41 GMT (Wednesday 6th July 2022)"
	revision: "1"

class
	PLATFORM_ECF_LINES

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
			Result := Name.platform
		end

feature {NONE} -- Implementation

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
		do
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				platform:
					value = $VALUE
			]"
		end

end