note
	description: "Summary description for {UNICODE_CHARACTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-19 15:01:50 GMT (Saturday 19th December 2015)"
	revision: "9"

class
	LATIN_CHARACTER

inherit
	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal
		end

	COMPARABLE

create
	make, make_with_unicode

feature {NONE} -- Initialization

	make (a_code: NATURAL)
		do
			make_default
			code := a_code
			create name.make_empty
		end

	make_with_unicode (a_code, a_unicode: NATURAL)
		do
			make (a_code)
			unicode := a_unicode
		end

feature -- Access

	code: NATURAL

	unicode: NATURAL

	name: ZSTRING

	unicode_string: ZSTRING
		do
			create Result.make (1)
			Result.append_unicode (unicode)
		end

	inverse_case_unicode_string: ZSTRING
		local
			c: CHARACTER_32
		do
			c := unicode.to_character_32
			create Result.make (1)
			if c.is_alpha then
				if c.is_upper then
					Result.append_unicode (c.as_lower.natural_32_code)
				else
					Result.append_unicode (c.as_upper.natural_32_code)
				end
			else
				Result.append_unicode (unicode)
			end
		end

	hexadecimal_code_string: ZSTRING
		do
			Result := code.to_hex_string
			Result.prune_all_leading ('0')
			Result.prepend_string_general (once "0x")
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if unicode = other.unicode then
				Result := code < other.code
			else
				Result := unicode < other.unicode
			end
		end

feature -- Status query

	is_alpha: BOOLEAN
		do
			Result := unicode.to_character_32.is_alpha
		end

	is_digit: BOOLEAN
		do
			Result := unicode.to_character_32.is_unicode_digit
		end

feature -- Element change

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_unicode (a_unicode: like unicode)
		do
			unicode := a_unicode
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["hex_code", 					agent hexadecimal_code_string],
				["unicode", 					agent unicode_string],
				["inverse_case_unicode", 	agent inverse_case_unicode_string],
				["code", 						agent: INTEGER_32_REF do Result := code.to_integer_32.to_reference end],
				["name", 						agent: ZSTRING do Result := name end]
			>>)
		end

end