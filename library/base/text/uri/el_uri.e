note
	description: "Uniform Resource Identifier as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

	         foo://example.com:8042/over/there?name=ferret#nose
	         \_/   \______________/\_________/ \_________/ \__/
	          |           |            |            |        |
	       scheme     authority       path        query   fragment
	          |   _____________________|__
	         / \ /                        \
	         urn:example:animal:ferret:nose
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 9:19:24 GMT (Monday 25th May 2020)"
	revision: "17"

class
	EL_URI

inherit
	STRING
		rename
			make as make_with_size,
			make_from_string as make,
			substring as uri_substring
		export
			{NONE} all
			{ANY} hash_code, to_string_8
			{STRING_HANDLER} append_string_general, wipe_out, share
		redefine
			make
		end

	EL_SHARED_ONCE_STRING_8

create
	make_empty, make

convert
	make ({STRING_8})

feature {NONE} -- Initialization

	make (uri: READABLE_STRING_8)
		require else
			valid_uri: uri.substring_index (Colon_slash_x2, 1) > 0
		do
			Precursor (uri)
		end

feature -- Access

	authority: STRING
		local
			start_index, index, end_index: INTEGER
		do
			start_index := authority_index
			if start_index > 0 then
				index := index_of (Separator, start_index)
				if index > 0 then
					end_index := index - 1
				end
			end
			if end_index > 0 then
				Result := substring (start_index, end_index, True)
			else
				Result := substring (1, 0, True)
			end
		end

	fragment: STRING
		local
			index: INTEGER
		do
			index := index_of ('#', 1)
			if index > 0 then
				Result := substring (index + 1, count, True)
			else
				Result := substring (1, 0, True)
			end
		end

	path: STRING
		do
			Result := internal_path (True)
		end

	query: STRING
		local
			index, start_index, end_index: INTEGER
		do
			index := index_of ('?', 1)
			if index > 0 then
				start_index := index + 1
				index := index_of ('#', start_index)
				if index > 0 then
					end_index := index - 1
				else
					end_index := count
				end
			end
			if end_index > 0 then
				Result := substring (start_index, end_index, True)
			else
				Result := substring (1, 0, True)
			end
		end

	scheme: STRING
		local
			index: INTEGER
		do
			index := index_of (':', 1)
			if index > 0 then
				Result := substring (1, index - 1, True)
			else
				Result := substring (1, 0, True)
			end
		end

feature -- Conversion

	to_dir_path: EL_DIR_PATH
		do
			create Result.make (copy_encoded_path.decoded_32 (False))
		end

	to_file_path: EL_FILE_PATH
		do
			create Result.make (copy_encoded_path.decoded_32 (False))
		end

feature {NONE} -- Implementation

	authority_index: INTEGER
		local
			index: INTEGER
		do
			index := substring_index (Colon_slash_x2, 1)
			if index > 0 then
				Result := index + Colon_slash_x2.count
			end
		end

	copy_encoded_path: like Encoded_path
		do
			Result := Encoded_path; Result.wipe_out
			Result.append_raw_8 (internal_path (False))
		end

	internal_path (keep_ref: BOOLEAN): STRING
		local
			start_index, index, end_index, i: INTEGER
		do
			index := authority_index
			if index > 0 then
				index := index_of (Separator, index)
				if index > 0 then
					start_index := index
					from i := 1; index := 0 until i > 2 or index > 0 loop
						index := index_of (Qmark_and_hash [i], start_index)
						i := i + 1
					end
					if index > 0 then
						end_index := index - 1
					else
						end_index := count
					end
				end
			end
			if end_index > 0 then
				Result := substring (start_index, end_index, keep_ref)
			else
				Result := substring (1, 0, keep_ref)
			end
		end

	substring (start_index, end_index: INTEGER; keep_ref: BOOLEAN): STRING
		do
			Result := empty_once_string_8
			Result.append_substring (Current, start_index, end_index)
			if keep_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	Colon_slash_x2: STRING = "://"

	Qmark_and_hash: STRING = "?#"

	Separator: CHARACTER = '/'

	Encoded_path: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

end
