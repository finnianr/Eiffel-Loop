note
	description: "[
		Wrapper object for enumeration value defined by a class inheriting from
		${EL_ENUMERATION}. An instance of an implemention class can
		be initialized by a name string either matching the enumeration name or imported
		from a foreign naming convention.
		 
		It is especially useful as a field attribute in a class inheriting ${EL_REFLECTIVE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "13"

deferred class
	EL_ENUMERATION_VALUE [N -> NUMERIC]

inherit
	EL_MAKEABLE_FROM_STRING [STRING_8]
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

feature -- Element change

	set_value (a_value: like value)
		require
			valid_valud: is_valid_value (a_value)
		do
			value := a_value
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := value = other.value
		end

feature -- Contract Support

	is_valid_value (a_value: like value): BOOLEAN
		do
			Result := enumeration.is_valid_value (a_value)
		end

feature {NONE} -- Implementation

	enumeration: EL_ENUMERATION [N]
		deferred
		end
end