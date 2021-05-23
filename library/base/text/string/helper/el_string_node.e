note
	description: "Abstraction to convert a node representing a string to a various string types"
	descendants: "[
			EL_STRING_NODE*
				[$source EL_DOCUMENT_NODE_STRING]
					[$source EL_ELEMENT_ATTRIBUTE_NODE_STRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-23 10:40:08 GMT (Sunday 23rd May 2021)"
	revision: "3"

deferred class
	EL_STRING_NODE

feature -- Basic operations

	as_string (keep_ref: BOOLEAN): ZSTRING
		deferred
		end

	as_string_8 (keep_ref: BOOLEAN): STRING_8
		deferred
		end

	as_string_32 (keep_ref: BOOLEAN): STRING_32
		deferred
		end

end