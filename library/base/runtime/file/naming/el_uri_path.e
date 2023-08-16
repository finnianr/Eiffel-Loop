note
	description: "Uniform Resource Identifier as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

			  foo://example.com:8042/over/there
			  \_/   \______________/\_________/
			   |           |            |
			scheme     authority       path
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 10:33:10 GMT (Wednesday 16th August 2023)"
	revision: "39"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		export
			{ANY} Forward_slash
		redefine
			append, append_file_prefix, default_create, make, make_from_other, normalized_copy,
			is_absolute, is_uri, is_equal, is_less,
			set_path, part_count, part_string, first_index,
			Separator, Type_parent
		end

	EL_PROTOCOL_CONSTANTS
		export
			{ANY} Protocol
		end

	EL_MODULE_URI

	EL_MODULE_REUSEABLE

	EL_STRING_8_CONSTANTS

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_PATH}
			authority := Empty_string; scheme := Empty_string_8
		end

feature -- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		local
			l_path: ZSTRING; start_index, pos_separator: INTEGER
		do
			l_path := temporary_copy (a_uri)
			start_index := a_uri.substring_index (Colon_slash_x2, 1)
			if start_index > 0 then
				across Reuseable.string_8 as reuse loop
					set_scheme (reuse.substring_item (a_uri, 1, start_index - 1))
				end
				l_path.remove_head (start_index + Colon_slash_x2.count - 1)
			else
				set_scheme (Protocol.file)
			end
			if scheme ~ Protocol.file then
				create authority.make_empty
				Precursor (l_path)
			else
				pos_separator := l_path.index_of (Separator, 1)
				if pos_separator = 0 then
					pos_separator := l_path.count + 1
				end
				authority := l_path.substring (1, pos_separator - 1)
				l_path.remove_head (pos_separator - 1)
				Precursor (l_path)
			end
		ensure then
			is_absolute: not has_scheme (Protocol.file) implies is_absolute
		end

	make_file (a_path: READABLE_STRING_GENERAL)
			-- make with implicit `file' scheme
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make_scheme (Protocol.file, create {EL_FILE_PATH}.make (a_path))
		end

	make_from_file_path (a_path: EL_PATH)
			-- make from file or directory path
		require
			absolute: a_path.is_absolute
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			else
				make_scheme (Protocol.file, a_path)
			end
		end

	make_from_other (other: EL_URI_PATH)
		do
			authority := other.authority.twin
			scheme := other.scheme
			Precursor {EL_PATH} (other)
		end

	make_from_encoded (a_uri: READABLE_STRING_8)
		do
			make_from_uri (create {EL_URI}.make (a_uri))
		end

	make_from_uri (a_uri: EL_URI)
		do
			make (a_uri.to_string)
		end

	make_scheme (a_scheme: STRING; a_path: EL_PATH)
		require
			path_absolute_for_file_scheme: a_scheme ~ Protocol.file implies a_path.is_absolute
			path_relative_for_other_schemes:
				(a_scheme /= Protocol.file and not attached {EL_URI_PATH} a_path) implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			else
				create l_path.make (a_scheme.count + Colon_slash_x2.count + a_path.count + 1)
				l_path.append_string_general (a_scheme)
				l_path.append_string_general (Colon_slash_x2)
				if {PLATFORM}.is_windows and a_path.is_absolute then
					l_path.append_character (separator)
				end
				a_path.append_to (l_path)
				if {PLATFORM}.is_windows then
					l_path.replace_character (Windows_separator, separator)
				end
				make (l_path)
			end
		end

feature -- Access

	authority: ZSTRING

	scheme: STRING

feature -- Element change

	append (a_path: EL_PATH)
		local
			s: EL_ZSTRING_ROUTINES
		do
			if is_empty and then a_path.is_absolute then
				if scheme ~ Protocol.file and {PLATFORM}.is_windows then
					set_parent_path (s.character_string (Unix_separator) + a_path.parent_path)
				else
					parent_path := a_path.parent_path
				end
				base := a_path.base.twin
			else
				Precursor (a_path)
			end
		end

	set_authority (a_authority: READABLE_STRING_GENERAL)
		do
			across Reuseable.string as reuse loop
				Authority_set.put_copy (reuse.copied_item (a_authority))
				authority := Authority_set.found_item
			end
		end

	set_scheme (a_scheme: STRING)
		do
			Scheme_set.put_copy (a_scheme)
			scheme := Scheme_set.found_item
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		do
			make (a_path)
		end

feature -- Status query

	is_absolute: BOOLEAN
		do
			if has_scheme (Protocol.file) and then attached parent_path as str then
				Result := str.starts_with_character (Separator)
			else
				Result := True
			end
		end

	is_uri: BOOLEAN
		do
			Result := True
		end

	has_scheme (a_scheme: STRING): BOOLEAN
		do
			Result := scheme ~ a_scheme
		end

feature -- Conversion

	to_file_path: EL_PATH
		deferred
		end

	to_encoded_utf_8: STRING
		local
			i: INTEGER; l_path: like empty_uri_path
		do
			l_path := empty_uri_path
			from i := 1 until i > part_count loop
				l_path.append_general (part_string (i))
				i := i + 1
			end
			create Result.make_from_string (l_path)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := Precursor {EL_PATH} (other) and then scheme ~ other.scheme and then authority ~ other.authority
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if scheme ~ other.scheme then
				if authority ~ other.authority then
					Result := Precursor (other)
				else
					Result := authority < other.authority
				end
			else
				Result := scheme < other.scheme
			end
		end

feature -- Contract Support

	is_uri_absolute (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_absolute (a_uri)
		end

	is_uri_string (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_valid (a_uri)
		end

feature {NONE} -- Implementation

	append_file_prefix (a_uri: EL_URI_STRING_8)
		do
		end

	first_index: INTEGER
		do
			Result := scheme.count + Colon_slash_x2.count + authority.count + 1
		end

	normalized_copy (path: READABLE_STRING_GENERAL): ZSTRING
		-- temporary path string normalized for platform
		do
			Result := temporary_copy (path)
		end

	part_count: INTEGER
		do
			Result := 5
		end

	part_string (index: INTEGER): READABLE_STRING_GENERAL
		do
			inspect index
				when 1 then
					Result := scheme
				when 2 then
					Result := Colon_slash_x2
				when 3 then
					Result := authority
				when 4 then
					Result := parent_path
			else
				Result := base
			end
		end

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_URI_PATH
		once
		end

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Unix_separator
		end

	Type_alias: ZSTRING
		-- localized description
		once
			Result := "URI"
		end

feature {NONE} -- Constants

	Authority_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (5)
		end

	Scheme_set: EL_HASH_SET [STRING]
		once
			create Result.make (5)
		end

	Separator_string: ZSTRING
		once
			Result := "/"
		end

end