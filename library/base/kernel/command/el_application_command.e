note
	description: "A ${EL_COMMAND} with a description and error checking"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_APPLICATION_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_NAMING

feature -- Access

	description: READABLE_STRING_GENERAL
		deferred
		end

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		do
		end

feature {NONE} -- Implementation

	default_description: STRING
		do
			Result := Naming.class_description_from (Current, excluded_words)
		end

feature {NONE} -- Constants

	Excluded_words: EL_STRING_8_LIST
		once
			Result := "EL, COMMAND, IMP"
		end

end