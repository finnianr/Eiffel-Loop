note
	description: "Summary description for {PP_VARIABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:51:50 GMT (Monday 18th December 2017)"
	revision: "2"

class
	PP_VARIABLE

inherit
	HASHABLE
		redefine
			is_equal
		end

	PP_SHARED_PARAMETER_ENUM
		undefine
			is_equal
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			is_equal
		end

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
				Result := Parameter.name (code)
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
			i: INTEGER; l_name, l_index: STRING
		do
			from i := a_name.count until not a_name.item (i).is_digit loop
				i := i - 1
			end

			l_name := empty_once_string_8
			a_name.append_to_string_8 (l_name)

			if i < a_name.count then
				l_index := Once_index_string; l_index.wipe_out
				l_index.append_substring (l_name, i + 1, a_name.count)
				index := l_index.to_integer + 1
			else
				index := 0
			end

			l_name.remove_tail (a_name.count - i)
			code := Parameter.value (l_name)

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

feature {PP_VARIABLE} -- Initialization

	internal_name: STRING

feature {NONE} -- Constants

	Once_index_string: STRING
		once
			create Result.make_empty
		end
end
