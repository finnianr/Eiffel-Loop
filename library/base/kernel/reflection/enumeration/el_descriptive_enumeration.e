note
	description: "[
		Enumeration with added descriptions parsed from text field `descriptions'
		See class [$source EL_REFLECTIVE_DESCRIPTIONS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 17:26:43 GMT (Sunday 16th July 2023)"
	revision: "5"

deferred class
	EL_DESCRIPTIVE_ENUMERATION [N -> NUMERIC]

inherit
	EL_REFLECTIVE_DESCRIPTIONS
		rename
			description_table as new_description_table
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			make_enumeration
			description_table := new_description_table
		end

feature -- Access

	description (a_value: N): ZSTRING
		do
			if description_table.has_key (name (a_value)) then
				Result := description_table.found_item.description
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Deferred

	make_enumeration
		deferred
		end

	name (a_value: N): IMMUTABLE_STRING_8
		deferred
		end

feature {NONE} -- Internal attributes

	description_table: like new_description_table
end