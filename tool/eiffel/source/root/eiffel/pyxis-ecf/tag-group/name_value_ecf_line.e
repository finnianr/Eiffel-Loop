note
	description: "[$source GROUPED_ECF_LINES] **name value** attribute pair line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 16:47:51 GMT (Wednesday 6th July 2022)"
	revision: "2"

class
	NAME_VALUE_ECF_LINE

inherit
	GROUPED_ECF_LINES
		rename
			make as make_empty
		redefine
			set_from_line, set_variables, Template
		end

create
	make

feature {NONE} -- Initialization

	make (a_tag_name: STRING)
		do
			make_empty
			tag_name := a_tag_name
		end

feature -- Access

	tag_name: STRING

feature -- Element change

	set_from_line (a_line: STRING; tab_count: INTEGER)
		do
			wipe_out
			if attached shared_name_value_list (a_line) as nvp_list
				and then nvp_list.count = 1
			then
				set_from_pair_list (nvp_list, tab_count)
			end
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
				name = $NAME; value = $VALUE
			]"
		end
end