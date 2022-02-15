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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 9:56:08 GMT (Tuesday 15th February 2022)"
	revision: "2"

deferred class
	EL_URI_ZPATH [TO_TYPE -> EL_ZPATH create default_create, make_sub_path end]

inherit
	EL_ZPATH
		redefine
			append_path, make, Separator, is_absolute, is_uri, last_is_empty
		end

	EL_MODULE_URI

feature -- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		do
			Precursor (a_uri)
		end

	make_file (a_path: READABLE_STRING_GENERAL)
			-- make with implicit `file' scheme
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make_scheme (Protocol.file, create {EL_FILE_ZPATH}.make (a_path))
		end

	make_from_encoded (a_uri: STRING)
		local
			qmark_index: INTEGER; l_path: like empty_uri_path
		do
			l_path := empty_uri_path
			qmark_index := a_uri.index_of ('?', 1)
			if qmark_index > 0 then
				l_path.append_substring (a_uri, 1, qmark_index - 1)
			else
				l_path.append_raw_8 (a_uri)
			end
			make (l_path.decoded_32 (False))
		end

	make_from_file_path (a_path: EL_ZPATH)
			-- make from file or directory path
		require
			absolute: a_path.is_absolute
		do
			if attached {like Current} a_path as l_uri_path then
				copy (l_uri_path)
			else
				make_scheme (Protocol.file, a_path)
			end
		end

	make_scheme (a_scheme: STRING; a_path: EL_ZPATH)
		require
			path_absolute_for_file_scheme: is_file_scheme (a_scheme) implies a_path.is_absolute
			path_relative_for_other_schemes:
				(not is_file_scheme (a_scheme) and not attached {EL_URI_ZPATH [EL_ZPATH]} a_path)
					implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if attached {like Current} a_path as l_uri_path then
				copy (l_uri_path)
				set_scheme (a_scheme)
			else
				l_path := temporary_copy (a_scheme)
				l_path.append_string_general (Colon_slash_x2)
				make_tokens (l_path.occurrences (Separator) + 1 + a_path.step_count)
				Step_table.put_tokens (l_path.split (Separator), area)
				if not ({PLATFORM}.is_windows and a_path.is_absolute) then
					remove_tail (1)
				end
				append (a_path)
			end
		end

feature -- Access

	authority: ZSTRING
		do
			Result := i_th_step (Index_authority).twin
		end

	scheme: STRING
		do
			Result := i_th_step (Index_scheme)
			Result.prune_all_trailing (':')
		end

feature -- Status query

	has_scheme (a_scheme: STRING): BOOLEAN
		do
			if step_count > 0 and then attached Step_table.to_step (i_th (1)) as l_scheme then
				Result := l_scheme.count - 1 = a_scheme.count and then l_scheme.starts_with_general (a_scheme)
			end
		end

	is_absolute: BOOLEAN
		do
			if has_scheme (Protocol.file) and then step_count >= Index_authority then
				Result := i_th (Index_authority)	= Step_table.token_empty_string
			else
				Result := True
			end
		end

	is_uri: BOOLEAN
		do
			Result := True
		end

	last_is_empty: BOOLEAN
		do
			Result := step_count > Index_authority and then Precursor
		end

feature -- Element change

	append_path (path: EL_ZPATH)
		require else
			valid_step_count: path.is_absolute implies step_count = Index_authority
		do
			Precursor (path)
		end

	set_authority (a_authority: READABLE_STRING_GENERAL)
		do
			put_i_th_step (a_authority, Index_authority)
		end

	set_scheme (a_scheme: STRING)
		do
			put_i_th_step (a_scheme, Index_scheme)
		end

feature -- Conversion

	to_file_path: TO_TYPE
		local
			token: INTEGER
		do
			if valid_index (Index_authority) then
				token := i_th (Index_authority)
				put_i_th (Step_table.token_empty_string, Index_authority)
				create Result.make_sub_path (Current, Index_authority)
				put_i_th (token, Index_authority)
			else
				create Result
			end
		end

feature -- Contract Support

	is_file_scheme (a_scheme: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := a_scheme.same_string (Protocol.file)
		end

	is_uri_absolute (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_absolute (a_uri)
		end

	is_uri_string (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_valid (a_uri)
		end

feature -- Constants

	Index_scheme: INTEGER = 1

	Index_authority: INTEGER = 3

	Separator: CHARACTER_32
		once
			Result := Unix_separator
		end

end