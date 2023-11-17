note
	description: "Implementation routines for [$source EL_REFLECTED_FIELD]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-17 13:50:53 GMT (Friday 17th November 2023)"
	revision: "2"

deferred class
	EL_REFLECTED_FIELD_IMPLEMENTATION

inherit
	EL_NAMEABLE [IMMUTABLE_STRING_8]

	EL_REFLECTION_CONSTANTS

	EL_REFLECTION_HANDLER

	EL_MODULE_EIFFEL

	EL_SHARED_IMMUTABLE_8_MANAGER

feature -- Access

	object_type: INTEGER
			-- dynamic type of enclosing object

	index: INTEGER

feature -- Measurement

	field_count: INTEGER
			-- Number of logical fields in `object'
		do
			Result := {ISE_RUNTIME}.field_count_of_type (object_type)
		end

feature {NONE} -- Implementation

	field_static_type (i: INTEGER): INTEGER
			-- Static type of declared `i'-th field of dynamic type `dynamic_type'
		require
			index_large_enough: i >= 1
			index_small_enough: i <= field_count
		do
			Result := {ISE_RUNTIME}.field_static_type_of_type (i, object_type)
		ensure
			field_type_nonnegative: Result >= 0
		end

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

	Buffer_32: EL_STRING_32_BUFFER
		once
			create Result
		end

end