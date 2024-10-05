note
	description: "Abstraction to set a field conforming to ${STRING_GENERAL} from a document node"
	descendants: "[
			EL_STRING_NODE*
				${EL_DOCUMENT_NODE_STRING}
					${EL_ELEMENT_ATTRIBUTE_NODE_STRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "7"

deferred class
	EL_STRING_NODE

feature -- Basic operations

	set (other: ZSTRING)
		-- set `other' from adjusted `Current'
		deferred
		end

	set_32 (other: STRING_32)
		-- set `other' from adjusted `Current'
		deferred
		end

	set_8 (other: STRING_8)
		-- set `other' from adjusted `Current'
		deferred
		end

feature -- Conversion

	as_string (keep_ref: BOOLEAN): ZSTRING
		deferred
		end

	as_string_32 (keep_ref: BOOLEAN): STRING_32
		deferred
		end

	as_string_8 (keep_ref: BOOLEAN): STRING_8
		deferred
		end

end