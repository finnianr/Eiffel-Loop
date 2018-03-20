note
	description: "[
		Wrapper object for enumeration value defined by a class inheriting from
		[$source EL_ENUMERATION]. An instance of an implemention class can
		be initialized by a name string either matching the enumeration name or imported
		from a foreign naming convention.
		 
		It is especially useful as a field attribute in a class inheriting [$source EL_REFLECTIVE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:04:58 GMT (Wednesday 21st February 2018)"
	revision: "6"

deferred class
	EL_ENUMERATION_VALUE [N -> {NUMERIC, HASHABLE}]

inherit
	EL_MAKEABLE_FROM_STRING_8
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make (name: STRING)
		require else
			valid_name: enumeration.is_valid_name (name)
		do
			value := enumeration.value (name)
		end

	make_default
		do
		end

feature -- Access

	to_string: STRING
		do
			Result := enumeration.name (value)
		end

	value: N

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := value = other.value
		end

feature {NONE} -- Implementation

	enumeration: EL_ENUMERATION [N]
		deferred
		end
end
