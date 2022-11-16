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
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_BOOLEAN_ENUMERATION

inherit
	EL_ENUMERATION [NATURAL_8]
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