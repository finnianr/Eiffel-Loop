note
	description: "Abstraction to set a string field from a cached value set"
	descendants: "[
			EL_CACHED_FIELD_READER*
				[$source EL_DOCUMENT_NODE_STRING]
					[$source EL_ELEMENT_ATTRIBUTE_NODE_STRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-05 13:45:50 GMT (Friday 5th March 2021)"
	revision: "2"

deferred class
	EL_CACHED_FIELD_READER

feature -- Basic operations

	read_string (set: EL_HASH_SET [ZSTRING])
		deferred
		end

	read_string_8 (set: EL_HASH_SET [STRING_8])
		deferred
		end

	read_string_32 (set: EL_HASH_SET [STRING_32])
		deferred
		end

end