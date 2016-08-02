note
	description: "URL encoded string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:30:48 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_URL_STRING

inherit
	STRING
		rename
			append as append_8,
			append_string_general as append_general,
			make_from_string as make_encoded,
			set as set_encoded
		export
			{NONE} all
			{ANY} append_general, Is_string_8, wipe_out, share, set_encoded, count, area
		redefine
			make_encoded, make_empty, append_general
		end

	EL_MODULE_UTF
		export
			{NONE} all
		undefine
			is_equal, copy, out
		end

create
	make_encoded, make_empty

convert
	make_encoded ({STRING})

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			is_plus_defined_as_space := True
		end

	make_encoded (s: READABLE_STRING_8)
		do
			Precursor (s)
			is_plus_defined_as_space := True
		end

feature -- Access

	is_plus_defined_as_space: BOOLEAN

feature -- Status change

	enable_space_escaping
		do
			is_plus_defined_as_space := False
		end

feature -- Conversion

	to_string: ZSTRING
		do
			create Result.make_from_utf_8 (to_utf_8)
		end

	to_utf_8: STRING
		local
			l_area: like area; i, nb, step: INTEGER
			c, hi_c, low_c: CHARACTER
		do
			create Result.make (count - occurrences ('%%') * 2)
			l_area := area; nb := count
			from i := 0 until i = nb loop
				c := l_area [i]; step := 1
				if c = '+' then
					Result.append_character (' ')
				elseif c = '%%' and then i + 2 < nb then
					hi_c := l_area [i + 1]; low_c := l_area [i + 2]
					if hi_c.is_hexa_digit and low_c.is_hexa_digit then
						Result.append_code ((to_decimal (hi_c) |<< 4) | to_decimal (low_c))
					end
					step := 3
				else
					Result.append_character (c)
				end
				i := i + step
			end
		end

feature -- Element change

	append_general (s: READABLE_STRING_GENERAL)
		do
			append_utf_8 (UTF.utf_32_string_to_utf_8_string_8 (s))
		end

	append_utf_8 (utf_8: STRING)
		local
			l_area: like area; i, nb: INTEGER; code_hi, code_low: NATURAL
			c: CHARACTER; plus_for_space: BOOLEAN
		do
			l_area := utf_8.area; nb := utf_8.count
			plus_for_space := is_plus_defined_as_space
			grow (count + nb)
			from i := 0 until i = nb loop
				c := l_area [i]
				if c.code = 32 and then plus_for_space then
					append_character ('+')
				elseif is_unescaped (c) then
					append_character (c)
				else
					code_hi := c.natural_32_code |>> 4
					code_low := c.natural_32_code & 0xF
					append_character ('%%')
					append_character (code_hi.to_hex_character)
					append_character (code_low.to_hex_character)
				end
				i := i + 1
			end
			internal_hash_code := 0
		ensure
			reversible: substring (old count + 1, count).to_utf_8.same_string (utf_8)
		end

	set_from_string (str: ZSTRING)
		do
			wipe_out
			append_utf_8 (str.to_utf_8)
		end

feature {NONE} -- Implementation

	is_unescaped (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'Z', 'a' .. 'z' then
					Result := True
				when '!', '#', '$', '&', ''', '(', ')', '*', '+', ',', '/', ':', ';', '=', '?', '@', '[', ']' then
					Result := True
				when '-', '_', '.', '~' then
					Result := True

			else end
		end

	to_decimal (hex: CHARACTER): NATURAL
		require
			is_hexadeciam: hex.is_hexa_digit
		do
			inspect hex
				when '0' .. '9' then
					Result := hex.natural_32_code - 48
				when 'a' .. 'z' then
					Result := hex.natural_32_code - 87
				when 'A' .. 'Z' then
					Result := hex.natural_32_code - 55
			else
			end
		end

end