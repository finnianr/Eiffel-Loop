note
	description: "Abstraction for objects that have a function returning all the basic types and strings"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 13:46:42 GMT (Monday 1st April 2024)"
	revision: "6"

deferred class
	EL_READABLE

feature -- Integer

	read_integer_8: INTEGER_8
		deferred
		end

	read_integer_16: INTEGER_16
		deferred
		end

	read_integer_32: INTEGER_32
		deferred
		end

	read_integer_64: INTEGER_64
		deferred
		end

feature -- Natural

	read_natural_8: NATURAL_8
		deferred
		end

	read_natural_16: NATURAL_16
		deferred
		end

	read_natural_32: NATURAL_32
		deferred
		end

	read_natural_64: NATURAL_64
		deferred
		end

feature -- Real

	read_real_32: REAL_32
		deferred
		end

	read_real_64: REAL_64
		deferred
		end

feature -- String

	read_string_8: STRING_8
		deferred
		end

	read_string_32: STRING_32
		deferred
		end

	read_string: ZSTRING
		deferred
		end

feature -- Access

	read_boolean: BOOLEAN
		deferred
		end

	read_pointer: POINTER
		deferred
		end

	read_character_8: CHARACTER
		deferred
		end

	read_character_32: CHARACTER_32
		deferred
		end
note
	descendants: "[
			EL_READABLE*
				${EL_DOCUMENT_NODE_STRING}
					${EL_ELEMENT_ATTRIBUTE_NODE_STRING}
				${EL_MEMORY_READER_WRITER_IMPLEMENTATION*}
					${EL_MEMORY_READER_WRITER}
						${ECD_READER_WRITER [G -> EL_STORABLE create make_default end]}
							${ECD_ENCRYPTABLE_READER_WRITER [G -> EL_STORABLE create make_default end]}
								${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
							${ECD_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
								${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
					${EL_MEMORY_STRING_READER_WRITER*}
						${EL_MEMORY_READER_WRITER}
				${EL_VTD_XPATH_QUERY}
	]"
end