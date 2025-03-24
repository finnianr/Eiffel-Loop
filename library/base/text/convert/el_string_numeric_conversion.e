note
	description: "Implementation details for ${EL_STRING_CONVERSION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-24 7:17:40 GMT (Monday 24th March 2025)"
	revision: "12"

deferred class
	EL_STRING_NUMERIC_CONVERSION

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			create integer_8_converter.make
			create integer_16_converter.make
			create integer_32_converter.make
			create integer_64_converter.make

			create natural_8_converter.make
			create natural_16_converter.make
			create natural_32_converter.make
			create natural_64_converter.make

			create real_32_converter.make
			create real_64_converter.make
		end

feature -- Integer substrings

	substring_to_integer_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_16
		do
			Result := integer_16_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_32
		do
			Result := integer_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_64
		do
			Result := integer_64_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_8
		do
			Result := integer_8_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Natural substrings

	substring_to_natural_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_16
		do
			Result := natural_16_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_32
		do
			Result := natural_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_64
		do
			Result := natural_64_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_8
		do
			Result := natural_8_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Real substrings

	substring_to_real_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_32
		do
			Result := real_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_real_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_64
		do
			Result := real_64_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Numeric conversion

	to_integer (str: READABLE_STRING_GENERAL): INTEGER
		require
			integer_string: is_integer (str)
		do
			Result := integer_32_converter.as_type (str)
		end

	to_integer_64 (str: READABLE_STRING_GENERAL): INTEGER_64
		require
			integer_64_string: is_integer_64 (str)
		do
			Result := integer_64_converter.as_type (str)
		end

	to_natural (str: READABLE_STRING_GENERAL): NATURAL_32
		require
			natural_string: is_natural (str)
		do
			Result := natural_32_converter.as_type (str)
		end

	to_natural_64 (str: READABLE_STRING_GENERAL): NATURAL_64
		require
			natural_string: is_natural (str)
		do
			Result := natural_64_converter.as_type (str)
		end

	to_real_32 (str: READABLE_STRING_GENERAL): REAL_32
		require
			real_32_string: is_real_32 (str)
		do
			Result := real_32_converter.as_type (str)
		end

	to_real_64 (str: READABLE_STRING_GENERAL): REAL_64
		require
			real_64_string: is_real_64 (str)
		do
			Result := real_64_converter.as_type (str)
		end

feature -- Numeric tests

	is_integer, is_integer_32 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := integer_32_converter.is_convertible (str)
		end

	is_integer_64 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := integer_64_converter.is_convertible (str)
		end

	is_natural, is_natural_32 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := natural_32_converter.is_convertible (str)
		end

	is_natural_64 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := natural_64_converter.is_convertible (str)
		end

	is_real_32 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := real_32_converter.is_convertible (str)
		end

	is_real_64 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := real_64_converter.is_convertible (str)
		end

feature {NONE} -- Internal attributes

	integer_16_converter: EL_STRING_TO_INTEGER_16

	integer_32_converter: EL_STRING_TO_INTEGER_32

	integer_64_converter: EL_STRING_TO_INTEGER_64

	integer_8_converter: EL_STRING_TO_INTEGER_8

	natural_16_converter: EL_STRING_TO_NATURAL_16

	natural_32_converter: EL_STRING_TO_NATURAL_32

	natural_64_converter: EL_STRING_TO_NATURAL_64

	natural_8_converter: EL_STRING_TO_NATURAL_8

	real_32_converter: EL_STRING_TO_REAL_32

	real_64_converter: EL_STRING_TO_REAL_64

end