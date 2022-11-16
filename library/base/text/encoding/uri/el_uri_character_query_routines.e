note
	description: "Character query routines for URI's"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_URI_CHARACTER_QUERY_ROUTINES

feature {NONE} -- Implementation

	is_generic_delimiter (c: CHARACTER_32): BOOLEAN
		-- `True' if `c' in set ":/?#[]@"
		-- Generic delimiters characters as defined in RFC 3986
		do
			inspect c
				when ':', '/', '?', '#', '[', ']', '@' then
					Result := True
			else
			end
		end

	is_subcomponent_delimiter (c: CHARACTER_32): BOOLEAN
		-- `True' if `c' in set "!$&'()*+,;="
		-- Subcomponent delimiter characters as defined in RFC 3986.
		do
			inspect c
				when '!', '$', '&', ''', '(', ')', '*', '+', ',', ';', '=' then
					Result := True
			else
			end
		end

	is_allowed_in_path_element (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when ':', '@' then
					Result := True
			else
				Result := is_subcomponent_delimiter (c)
			end
		end

	is_allowed_in_path (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '/' then
					Result := True
			else
				Result := is_allowed_in_path_element (c)
			end
		end

	is_allowed_in_query (c: CHARACTER_32): BOOLEAN
		-- Breaks RFC which allows `&' and `='
		do
			inspect c
				when '?' then
					Result := True

				when '&', '=' then
					Result := False -- not allowed

			else
				Result := is_allowed_in_path (c)
			end
		end

	is_allowed_in_userinfo (c: CHARACTER_32): BOOLEAN
		-- Allowed characters in userinfo as defined in RFC 3986.
		do
			inspect c
				when ':' then
					Result := True
			else
				Result := is_subcomponent_delimiter (c)
			end
		end

	is_rfc_2396_mark (c: CHARACTER_32): BOOLEAN
		-- RFC 2396 'mark' characters
		do
			inspect c
				when '!', '*', '%%', ''', '(', ')' then
					Result := True
			else
			end
		end
end