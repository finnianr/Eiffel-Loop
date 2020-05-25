note
	description: "[
		URI reserved characters based on 
		[https://code.woboq.org/gtk/include/glib-2.0/glib/gurifuncs.h.html include/glib-2.0/glib/gurifuncs.h.html]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:44:22 GMT (Sunday 24th May 2020)"
	revision: "1"

deferred class
	EL_SHARED_URI_RESERVED_CHARS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	URI_reserved_chars: TUPLE [
		allowed_in_path_element, allowed_in_path, allowed_in_query, allowed_in_userinfo,
		generic_delimiters, rfc_2396, subcomponent_delimiters: STRING
	]
		once
			create Result
			-- Generic delimiters characters as defined in RFC 3986
			Result.generic_delimiters := ":/?#[]@"

			-- Subcomponent delimiter characters as defined in RFC 3986.
			Result.subcomponent_delimiters := "!$&'()*+,;="

			Result.allowed_in_path_element := Result.subcomponent_delimiters + ":@"
			Result.allowed_in_path := Result.allowed_in_path_element + "/"

			-- Breaks RFC which allows `&' and `='
			Result.allowed_in_query := Result.allowed_in_path + "?"
			Result.allowed_in_query.prune ('&')
			Result.allowed_in_query.prune ('=')

			-- Allowed characters in userinfo as defined in RFC 3986.
			Result.allowed_in_userinfo := Result.subcomponent_delimiters + ":"

			-- RFC 2396 'mark' characters
			Result.rfc_2396 := "!*%'()"

		end
end
