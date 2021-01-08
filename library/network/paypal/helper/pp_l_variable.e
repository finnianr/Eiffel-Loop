note
	description: "[
		Indexed Paypal variable. Initializing with Paypal variable `L_BUTTONTYPE0' for example,
		will set `code' to the enumeration value of `L_BUTTONTYPE' specified in class 
		[$source PP_L_VARIABLE_ENUM]. `index' will be set to `0 + 1' since Eiffel generally uses
		1 based indices.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 16:04:47 GMT (Friday 8th January 2021)"
	revision: "9"

class
	PP_L_VARIABLE

inherit
	HASHABLE
		redefine
			is_equal
		end

	EL_STRING_8_CONSTANTS

	PP_SHARED_L_VARIABLE_ENUM

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

feature -- Element change

	set_code (a_code: like code)
		do
			code := a_code
		end

	set_from_string (a_name: ZSTRING)
		local
			i: INTEGER; l_name, l_index: STRING; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			from i := a_name.count until not a_name.item (i).is_digit loop
				i := i - 1
			end
			l_name := buffer.copied_general (a_name)

			if i < a_name.count then
				l_index := Once_index_string; l_index.wipe_out
				l_index.append_substring (l_name, i + 1, a_name.count)
				index := l_index.to_integer + 1
			else
				index := 0
			end

			l_name.remove_tail (a_name.count - i)
			code := L_variable.value (l_name)

			if code = 0 then
				create internal_name.make_from_string (l_name)
			else
				internal_name := Empty_string_8
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

feature {NONE} -- Constants

	Once_index_string: STRING
		once
			create Result.make_empty
		end
end