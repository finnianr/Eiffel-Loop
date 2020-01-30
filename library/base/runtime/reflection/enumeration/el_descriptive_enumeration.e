note
	description: "[
		Enumeration with added descriptions parsed from text field `descriptions'
		See class [$source EL_REFLECTIVE_DESCRIPTIONS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 11:44:31 GMT (Thursday 30th January 2020)"
	revision: "2"

deferred class
	EL_DESCRIPTIVE_ENUMERATION [N -> {NUMERIC, HASHABLE}]

inherit
	EL_ENUMERATION [N]
		redefine
			make
		end

	EL_REFLECTIVE_DESCRIPTIONS
		rename
			description_table as new_description_table
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			Precursor
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

feature {NONE} -- Internal attributes

	description_table: like new_description_table
end
