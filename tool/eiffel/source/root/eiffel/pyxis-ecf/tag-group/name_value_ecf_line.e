note
	description: "[$source GROUPED_ECF_LINES] **name value** attribute pair line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-21 11:43:51 GMT (Thursday 21st July 2022)"
	revision: "6"

class
	NAME_VALUE_ECF_LINE

inherit
	GROUPED_ECF_LINES
		rename
			make as make_empty,
			target as text
		export
			{PYXIS_ECF_PARSER} text
		redefine
			set_from_line, set_variables, Template
		end

create
	make

feature {NONE} -- Initialization

	make (a_tag_name: STRING; reserved_extra: ARRAY [STRING])
		do
			make_empty
			tag_name := a_tag_name
			create reserved_names.make_from_array (Reserved_name_set)
			reserved_names.append (reserved_extra)
		end

feature -- Access

	tag_name: STRING

feature -- Element change

	set_from_line (line: STRING)
		do
			wipe_out
			if attached shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1
			then
				set_from_pair_list (nvp_list)
			end
		end

	is_first_name_reserved (a_line: EL_PYXIS_LINE; equal_index: INTEGER): BOOLEAN
		do
			Result := across reserved_names as reserved some a_line.first_name_matches (reserved.item, equal_index) end
		end

feature {NONE} -- Implementation

	set_variables (nvp: ECF_NAME_VALUE_PAIR)
		do
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Internal attributes

	reserved_names: EL_STRING_8_LIST

feature {NONE} -- Constants

	Reserved_name_set: ARRAY [STRING]
		once
			Result := << Name.name, Name.value >>
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				name = $NAME; value = $VALUE
			]"
		end
end