note
	description: "Reference field that can be set from a set of cached values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-02 12:04:43 GMT (Thursday 2nd April 2020)"
	revision: "1"

deferred class
	EL_CACHEABLE_REFLECTED_REFERENCE [G -> HASHABLE]

inherit
	EL_REFLECTED_REFERENCE [G]

feature -- Basic operations

	read_from_set (a_object: EL_REFLECTIVE; reader: EL_CACHED_FIELD_READER; a_set: EL_HASH_SET [G])
		deferred
		end

end
