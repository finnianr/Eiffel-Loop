note
	description: "Uri path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-04 15:26:49 GMT (Wednesday 4th September 2019)"
	revision: "11"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		export
			{ANY} Forward_slash
		redefine
			default_create, make, make_from_other,
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
		end

	EL_MODULE_UTF

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_PATH}
			domain := Empty_path
			protocol := Empty_path
		end

feature -- Initialization

	make (a_uri: ZSTRING)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		local
			l_uri_path: like uri_path; pos_separator: INTEGER
		do
			protocol := uri_protocol (a_uri)
			l_uri_path := uri_path (a_uri)
			if protocol ~ Protocol_name.file then
				create domain.make_empty
				Precursor (l_uri_path)
			else
				pos_separator := l_uri_path.index_of (Separator, 1)
				domain := l_uri_path.substring (1, pos_separator - 1)
				Precursor (l_uri_path.substring_end (pos_separator))
			end
		ensure then
			is_absolute: is_absolute
		end

	make_file (a_path: ZSTRING)
			-- make with implicit `file' protocol
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make (Protocol_name.file + Protocol_sign + a_path)
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
				make_file (a_path.to_string)
			end
		end

	make_from_other (other: EL_URI_PATH)
		do
			Precursor {EL_PATH} (other)
			domain := other.domain.twin
			protocol := other.protocol.twin
		end

	make_protocol (a_protocol: ZSTRING; a_path: EL_PATH)
		require
			path_absolute_for_file_protocol: a_protocol ~ Protocol_name.file implies a_path.is_absolute
			path_relative_for_other_protocols:
				(a_protocol /~ Protocol_name.file and not attached {EL_URI_PATH} a_path) implies not a_path.is_absolute
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
				set_protocol (a_protocol)
			else
				make (a_protocol + Protocol_sign + a_path.to_string)
			end
		end

feature -- Access

	domain: ZSTRING

	protocol: ZSTRING

feature -- Element change

	set_protocol (a_protocol: like protocol)
		do
			protocol := a_protocol
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

	is_uri_absolute (a_uri: ZSTRING): BOOLEAN
		do
			if uri_protocol (a_uri) ~ Protocol_name.file then
				Result := uri_path (a_uri).starts_with (Forward_slash)
			else
				Result := uri_path (a_uri).has (Forward_slash [1])
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

	Separator_string: ZSTRING
		once
			Result := "/"
		end

end
