note
	description: "Implementation routines for ${EL_REFLECTED_FIELD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

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
		-- Static type of declared `i'-th field of dynamic type `field_static_type_of_type'
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