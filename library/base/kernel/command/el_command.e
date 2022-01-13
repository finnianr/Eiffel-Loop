note
	description: "Command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 15:51:02 GMT (Thursday 13th January 2022)"
	revision: "6"

deferred class
	EL_COMMAND

inherit
	ANY

	EL_MODULE_NAMING

feature -- Access

	description: READABLE_STRING_GENERAL
		deferred
		end

feature -- Basic operations

	execute
		deferred
		end

feature {NONE} -- Implementation

	default_description: STRING
		do
			Result := Naming.class_description (Current, excluded_words)
		end

feature {NONE} -- Constants

	Excluded_words: EL_STRING_8_LIST
		once
			Result := "EL, COMMAND, IMP"
		end

end