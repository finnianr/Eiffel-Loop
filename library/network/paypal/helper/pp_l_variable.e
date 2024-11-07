note
	description: "[
		Indexed Paypal variable. Initializing with Paypal variable `L_BUTTONTYPE0' for example,
		will set `code' to the enumeration value of `L_BUTTONTYPE' specified in class 
		${PP_L_VARIABLE_ENUM}. `index' will be set to `0 + 1' since Eiffel generally uses
		1 based indices.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 15:48:51 GMT (Tuesday 5th November 2024)"
	revision: "13"

class
	PP_L_VARIABLE

inherit
	HASHABLE
		redefine
			is_equal
		end

	EL_MODULE_CONVERT_STRING

	EL_STRING_8_CONSTANTS

	PP_SHARED_L_VARIABLE_ENUM

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			internal_name := Empty_string_8
		end

	make (a_name: ZSTRING)
		do
			set_from_string (a_name)
		end

feature -- Access

	code: NATURAL_8

	hash_code: INTEGER
		do
			if code = 0 then
				Result := internal_name.hash_code
			else
				Result := code.hash_code + index.hash_code
			end
		end

	index: INTEGER
		-- qualifying index

	name: STRING
		do
			if code = 0 then
				Result := internal_name
			else
				Result := L_variable.name (code)
			end
		end

feature -- Status query

	is_code (a_code: like code): BOOLEAN
		do
			Result := code = a_code
		end

	is_button_variable: BOOLEAN
		do
			Result := code = L_variable.l_button_var
		end

	is_error: BOOLEAN
		do
			Result := L_variable.error_variables.has (code)
		end

	is_error_code: BOOLEAN
		do
			Result := code = L_variable.l_error_code
		end

	is_option: BOOLEAN
		do
			Result := L_variable.option_variables.has (code)
		end

feature -- Element change

	set_code (a_code: like code)
		do
			code := a_code
		end

	set_from_string (a_name: ZSTRING)
		local
			i: INTEGER
		do
			from i := a_name.count until not a_name.item (i).is_digit loop
				i := i - 1
			end
			if i < a_name.count then
				index := Convert_string.substring_to_integer_32 (a_name, i + 1, a_name.count) + 1
			else
				index := 0
			end
			if attached String_8_pool.borrowed_item as borrowed then
				if attached borrowed.copied_substring_general (a_name, 1, i) as l_name then
					code := L_variable.value (l_name)
					if code = 0 then
						internal_name := l_name.twin
					else
						internal_name := Empty_string_8
					end
				end
				borrowed.return
			end
		end

	set_index (a_index: like index)
		do
			index := a_index
		end

feature -- Conversion

	to_string: STRING
		do
			Result := name
			if index > 0 then
				Result.append_integer (index - 1)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if code = 0 then
				Result := name ~ other.name and then index = other.index
			else
				Result := code = other.code and then index = other.index
			end
		end

feature {PP_L_VARIABLE} -- Initialization

	internal_name: STRING

end