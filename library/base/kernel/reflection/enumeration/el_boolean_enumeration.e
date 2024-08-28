note
	description: "[
		Enumeration with two values representing True and False. The values can be renamed in descendant
		
		Examples:
		
			confirmed/unconfirmed
			yes/no
			etc..
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 6:39:41 GMT (Wednesday 28th August 2024)"
	revision: "4"

deferred class
	EL_BOOLEAN_ENUMERATION

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions
		redefine
			initialize_fields
		end

feature {NONE} -- Initialization

	initialize_fields
			-- initialize fields with unique value
		do
			is_true := 1
		end

feature -- Access

	is_false: NATURAL_8

	is_true: NATURAL_8

end