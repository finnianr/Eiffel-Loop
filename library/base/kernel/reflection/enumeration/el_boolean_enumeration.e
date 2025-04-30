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
	date: "2025-04-30 12:25:30 GMT (Wednesday 30th April 2025)"
	revision: "7"

deferred class
	EL_BOOLEAN_ENUMERATION

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as default_translater
		redefine
			initialize_fields
		end

feature {NONE} -- Initialization

	initialize_fields (field_list: EL_FIELD_LIST)
		-- initialize fields with unique value
		do
			is_true := 1
		end

feature -- Access

	is_false: NATURAL_8

	is_true: NATURAL_8

end