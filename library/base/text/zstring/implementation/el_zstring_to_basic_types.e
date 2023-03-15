note
	description: "Routines to convert instance of [$source ZSTRING] to basic and numeric types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 11:12:19 GMT (Wednesday 15th March 2023)"
	revision: "3"

deferred class
	EL_ZSTRING_TO_BASIC_TYPES

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_TYPE_CONVERSION_HANDLER

feature -- Status query

	is_boolean: BOOLEAN
			-- Does `Current' represent a BOOLEAN?
		do
			Result := current_string_8.is_boolean
		end

	is_double, is_real_64: BOOLEAN
		do
			Result := current_string_8.is_double
		end

	is_real, is_real_32: BOOLEAN
		do
			Result := current_string_8.is_double
		end

	is_integer_8: BOOLEAN
		do
			Result := current_string_8.is_integer_8
		end

	is_integer_16: BOOLEAN
		do
			Result := current_string_8.is_integer_16
		end

	is_integer, is_integer_32: BOOLEAN
		do
			Result := current_string_8.is_integer
		end

	is_integer_64: BOOLEAN
		do
			Result := current_string_8.is_integer_64
		end

	is_natural_8: BOOLEAN
		do
			Result := current_string_8.is_natural_8
		end

	is_natural_16: BOOLEAN
		do
			Result := current_string_8.is_natural_16
		end

	is_natural, is_natural_32: BOOLEAN
		do
			Result := current_string_8.is_natural
		end

	is_natural_64: BOOLEAN
		do
			Result := current_string_8.is_natural_64
		end

feature -- To naturals

	to_natural_8: NATURAL_8
		do
			Result := current_string_8.to_natural_8
		end

	to_natural_16: NATURAL_16
		do
			Result := current_string_8.to_natural_16
		end

	to_natural, to_natural_32: NATURAL_32
		do
			Result := current_string_8.to_natural_32
		end

	to_natural_64: NATURAL_64
		do
			Result := current_string_8.to_natural_64
		end

feature -- To integers

	to_integer_8: INTEGER_8
		do
			Result := current_string_8.to_integer_8
		end

	to_integer_16: INTEGER_16
		do
			Result := current_string_8.to_integer_16
		end

	to_integer, to_integer_32: INTEGER_32
		do
			Result := current_string_8.to_integer_32
		end

	to_integer_64: INTEGER_64
		do
			Result := current_string_8.to_integer_64
		end

feature -- To reals

	to_double, to_real_64: DOUBLE
		do
			Result := current_string_8.to_real_64
		end

	to_real, to_real_32: REAL
		do
			Result := current_string_8.to_real_32
		end

feature -- To basic

	to_boolean: BOOLEAN
		do
			Result := current_string_8.to_boolean
		end

feature {NONE} -- Implementation

	is_valid_integer_or_natural (type: INTEGER) : BOOLEAN
			-- Is `Current' a valid number according to given `type'?
		do
			Result := current_string_8.is_valid_integer_or_natural (type)
		end

end