note
	description: "Latin character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:04:49 GMT (Sunday 22nd September 2024)"
	revision: "11"

class
	LATIN_CHARACTER

inherit
	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal
		end

	COMPARABLE

create
	make

convert
	make ({NATURAL})

feature {NONE} -- Initialization

	make (a_code: NATURAL)
		do
			make_default
			code := a_code; unicode := a_code
			create name.make_empty
		end

feature -- Access

	code: NATURAL
		-- latin-1 code

	hexadecimal_code_string: ZSTRING
		do
			Result := code.to_hex_string
			Result.prune_all_leading ('0')
			Result.prepend_string_general (once "0x")
		end

	inverse_case_unicode_string: ZSTRING
		local
			c: CHARACTER_32
		do
			c := unicode.to_character_32
			if c.is_alpha then
				if c.is_upper then
					create Result.make_filled (c.as_lower, 1)
				else
					create Result.make_filled (c.as_upper, 1)
				end
			else
				create Result.make_filled (c, 1)
			end
		end

	name: ZSTRING

	unicode: NATURAL

	unicode_string: ZSTRING
		do
			create Result.make_filled (unicode.to_character_32, 1)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := if unicode = other.unicode then code < other.code else unicode < other.unicode end
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

	is_unused: BOOLEAN
		do
			Result := unicode = Unicode_substitute
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
			create Result.make_assignments (<<
				["hex_code",				 agent hexadecimal_code_string],
				["unicode",					 agent unicode_string],
				["inverse_case_unicode", agent inverse_case_unicode_string],
				["code",						 agent: INTEGER_32_REF do Result := code.to_integer_32.to_reference end],
				["name",						 agent: ZSTRING do Result := name end]
			>>)
		end

feature {NONE} -- Constants

	Unicode_substitute: NATURAL = 0xFFFD
end