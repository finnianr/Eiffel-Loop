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
	date: "2025-04-28 17:29:22 GMT (Monday 28th April 2025)"
	revision: "6"

deferred class
	EL_BOOLEAN_ENUMERATION

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text
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