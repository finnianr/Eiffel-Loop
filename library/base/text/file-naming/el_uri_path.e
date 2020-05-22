note
	description: "Uri path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 17:27:37 GMT (Friday 22nd May 2020)"
	revision: "15"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		export
			{ANY} Forward_slash
		redefine
			default_create, make, make_from_other, escaped,
			is_uri, is_equal, is_less,
			set_path, part_count, part_string,
			Separator, Type_parent
		end

	EL_URI_ROUTINES
		rename
			Protocol as Protocol_name,
			is_uri as is_uri_string
		export
			{NONE} all
			{ANY} is_uri_of_type, is_uri_string, Protocol_name, uri_path
		undefine
			copy, default_create, is_equal, out
		end

	EL_MODULE_UTF

	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_PATH}
			domain := Empty_path
			protocol := Empty_path
		end

feature -- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		local
			l_path, l_protocol: ZSTRING; start_index, pos_separator: INTEGER
		do
			l_path := temporary_copy (a_uri)
			start_index := a_uri.substring_index (Protocol_sign, 1)
			if start_index > 0 then
				l_protocol := empty_once_string
				l_protocol.append_substring_general (a_uri, 1, start_index - 1)
				set_protocol (l_protocol)
				l_path.remove_head (start_index + Protocol_sign.count - 1)
			end
			if protocol ~ Protocol_name.file then
				create domain.make_empty
				Precursor (l_path)
			else
				pos_separator := l_path.index_of (Separator, 1)
				domain := l_path.substring (1, pos_separator - 1)
				l_path.remove_head (pos_separator - 1)
				Precursor (l_path)
			end
		ensure then
			is_absolute: is_absolute
		end

	make_file (a_path: READABLE_STRING_GENERAL)
			-- make with implicit `file' protocol
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make_protocol (Protocol_name.file, create {EL_FILE_PATH}.make (a_path))
		end

	make_from_file_path (a_path: EL_PATH)
			-- make from file or directory path
		require
			absolute: a_path.is_absolute
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			elseif {PLATFORM}.is_windows then
				make_file (Forward_slash + a_path.as_unix.to_string)
			else
				make_protocol (Protocol_name.file, a_path)
			end
		end

	make_from_other (other: EL_URI_PATH)
		do
			domain := other.domain.twin
			protocol := other.protocol
			Precursor {EL_PATH} (other)
		end

	make_protocol (a_protocol: READABLE_STRING_GENERAL; a_path: EL_PATH)
		require
			path_absolute_for_file_protocol: Protocol_name.file.same_string (a_protocol) implies a_path.is_absolute
			path_relative_for_other_protocols:
				(a_protocol /~ Protocol_name.file and not attached {EL_URI_PATH} a_path) implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			else
				create l_path.make (a_protocol.count + Protocol_sign.count + a_path.count)
				l_path.append_string_general (a_protocol)
				l_path.append (Protocol_sign)
				a_path.append_to (l_path)
				make (l_path)
			end
		end

feature -- Access

	domain: ZSTRING

	protocol: ZSTRING

feature -- Element change

	set_protocol (a_protocol: READABLE_STRING_GENERAL)
		local
			l_protocol: ZSTRING
		do
			if attached {ZSTRING} a_protocol as zstr then
				l_protocol := zstr
			else
				l_protocol := temporary_copy (a_protocol)
			end
			if Protocol_set.has_key (l_protocol) then
				protocol := Protocol_set.found_item
			else
				protocol := l_protocol.twin
				Protocol_set.put (protocol)
			end
		end

	set_path (a_path: ZSTRING)
		do
			make (a_path)
		end

feature -- Status query

	is_uri: BOOLEAN
		do
			Result := True
		end

feature -- Conversion

	escaped: ZSTRING
		do
			Result := to_encoded_utf_8
		end

	to_file_path: EL_PATH
		deferred
		end

	to_encoded_utf_8: STRING
		local
			string: ZSTRING; url: EL_URL_STRING_8
		do
			string := to_string
			create url.make_empty
			url.append_substring_general (string, protocol.count + Protocol_sign.count + 1, string.count)
			Result := (protocol + Protocol_sign).to_string_8 + url.to_string_8
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := Precursor {EL_PATH} (other) and then protocol ~ other.protocol and then domain ~ other.domain
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if protocol ~ other.protocol then
				if domain ~ other.domain then
					Result := Precursor (other)
				else
					Result := domain < other.domain
				end
			else
				Result := protocol < other.protocol
			end
		end

feature -- Contract Support

	is_uri_absolute (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		local
			uri: ZSTRING
		do
			uri := temporary_copy (a_uri)
			if uri_protocol (uri) ~ Protocol_name.file then
				Result := uri_path (uri).starts_with (Forward_slash)
			else
				Result := uri_path (uri).has (Forward_slash [1])
			end
		end

feature {NONE} -- Implementation

	part_count: INTEGER
		do
			Result := 5
		end

	part_string (index: INTEGER): ZSTRING
		do
			inspect index
				when 1 then
					Result := protocol
				when 2 then
					Result := Protocol_sign
				when 3 then
					Result := domain
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

feature {NONE} -- Constants

	Protocol_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (50)
		end

	Separator_string: ZSTRING
		once
			Result := "/"
		end

end
