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
	date: "2020-04-02 8:18:21 GMT (Thursday 2nd April 2020)"
	revision: "1"

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
