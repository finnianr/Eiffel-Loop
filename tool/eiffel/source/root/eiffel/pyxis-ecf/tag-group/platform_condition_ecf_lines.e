note
	description: "[
		${GROUPED_ECF_LINES} for adding C externals group platform condition
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	PLATFORM_CONDITION_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			make, set_variables, Template
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create platform_name.make_empty
		end

feature -- Access

	tag_name: STRING
		do
			Result := Name.condition
		end

feature -- Element change

	set (platform: STRING; indent_count: INTEGER)
		do
			wipe_out
			platform_name.value.share (platform)
			if attached Once_name_value_list as list then
				list.wipe_out
				list.extend (platform_name)
				set_from_pair_list (list)
			end
			set_indent (indent_count)
		end

feature {NONE} -- Implementation

	set_variables (nvp: ECF_NAME_VALUE_PAIR)
		do
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Internal attributes

	platform_name: ECF_NAME_VALUE_PAIR

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				condition:
					platform:
						value = $VALUE
			]"
		end

end