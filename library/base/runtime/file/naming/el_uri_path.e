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
	date: "2024-11-06 11:32:17 GMT (Wednesday 6th November 2024)"
	revision: "51"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		export
			{ANY} Forward_slash
		redefine
			append, append_file_prefix, as_string_32, default_create, make, make_from_other,
			is_absolute, is_uri, is_equal, is_less, part_count, part_string, first_index,
			set_path, set_volume_from_string,
			Separator, Type_parent
		end

	EL_PROTOCOL_CONSTANTS
		export
			{ANY} Protocol
		end

	EL_MODULE_URI

	EL_STRING_8_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_POOL

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
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			l_path := temporary_copy (a_uri, 1)
			start_index := a_uri.substring_index (Colon_slash_x2, 1)
			if start_index > 0 then
				set_scheme (buffer.copied_substring_general (a_uri, 1, start_index - 1))
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
			valid_scheme_path: is_valid_scheme_path (a_scheme, a_path)
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
		do
			if is_empty and then a_path.is_absolute then
				if attached temp_normalized (a_path.parent_path) as path then
					if not path.starts_with_character (Separator) then
						path.prepend_character (Separator)
					end
					set_shared_parent_path (path)
				end
				base := a_path.base.twin
			else
				Precursor (a_path)
			end
		end

	set_authority (a_authority: READABLE_STRING_GENERAL)
		do
			if attached String_pool.borrowed_item as borrowed then
				Authority_set.put_copy (borrowed.copied_general (a_authority))
				authority := Authority_set.found_item
				borrowed.return
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
			if scheme ~ Protocol.file and then attached parent_path as str then
				Result := str.starts_with_character (Separator)
			else
				Result := True
			end
		end

	is_uri: BOOLEAN
		do
			Result := True
		end

	has_scheme (a_scheme: READABLE_STRING_8): BOOLEAN
		do
			Result := scheme.same_string (a_scheme)
		end

feature -- Conversion

	as_string_32: STRING_32
		do
			create Result.make (count)
			append_to_32 (Result)
		end

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

	is_valid_scheme_path (a_scheme: STRING; a_path: EL_PATH): BOOLEAN
		local
			path_is_absolute: BOOLEAN
		do
			path_is_absolute := a_path.is_absolute
			if a_scheme ~ Protocol.file then
				Result := path_is_absolute
			else
				Result := not a_path.is_uri implies not path_is_absolute
			end
		end

feature {NONE} -- Implementation

	append_file_prefix (a_uri: EL_URI_STRING_8)
		do
		end

	first_index: INTEGER
		do
			Result := scheme.count + Colon_slash_x2.count + authority.count + 1
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

	set_volume_from_string (a_path: READABLE_STRING_GENERAL): INTEGER
		-- URI do not have a volume letter
		do
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
			create Result.make_equal (5)
		end

	Scheme_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (5)
		end

	Separator_string: ZSTRING
		once
			Result := "/"
		end

end