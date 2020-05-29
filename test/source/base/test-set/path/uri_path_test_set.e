note
	description: "URI path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 17:58:20 GMT (Thursday 28th May 2020)"
	revision: "8"

class
	URI_PATH_TEST_SET

inherit
	EL_EQA_TEST_SET

	ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("directory_join", agent test_directory_join)
			eval.call ("uri_assignments", agent test_uri_assignments)
			eval.call ("url_parts", agent test_url_parts)
		end

feature -- Tests

	test_directory_join
		local
			joined_dir: EL_DIR_PATH; root: EL_DIR_URI_PATH
			joined: ZSTRING
		do
			joined := Uri_strings [1]
			root := joined
			joined_dir := root.joined_dir_path (sd_card)
			joined.append (Sd_card)
			assert ("", joined_dir.to_string ~ joined)
		end

	test_uri_assignments
		local
			uri: EL_DIR_URI_PATH; str_32: STRING_32
		do
			across Uri_strings as line loop
				str_32 := line.item.to_string_32
				create uri.make (str_32)
				assert ("str_32 same as uri.to_string", str_32 ~ uri.to_string.to_string_32)
			end
		end

	test_url_parts
		local
			end_index, index: INTEGER; table: EL_URI_QUERY_ZSTRING_HASH_TABLE
			url: EL_URL; scheme, authority, path, query, s, base_uri, uri_string: STRING
			name, value: ZSTRING
		do
			across << "", "?name=ferret", "#nose", "?name=ferret#nose" >> as tail loop
				uri_string := "foo://example.com:8042/over/there" + tail.item
				url := uri_string
				scheme := uri_string.substring (1, uri_string.index_of (':', 1) - 1)
				assert ("scheme ok", url.scheme ~ scheme)

				s := scheme + "://"
				authority := uri_string.substring (s.count + 1, uri_string.index_of ('/', s.count + 1) - 1)
				assert ("authority ok", url.authority ~ authority)

				s := s + authority
				path := path_string (uri_string, s.count)
				assert ("path ok", url.path ~ path)

				s := s + path; query := query_string (uri_string, s.count)
				assert ("query ok", url.query ~ query)

				if not query.is_empty then
					s := s + "?" + query
				end
				assert ("fragment ok", url.fragment ~ fragment_string (uri_string, s.count))

				url.set_path (Trade_mark_path)
				assert ("same path", url.to_file_path.as_string_32 ~ Trade_mark_path)

				url.set_query_from_table (Book_table)
				table := url.query_table
				assert ("same count", table.count = Book_table.count)
				across Book_table as t loop
					name := t.key; value := t.item
					assert ("valid " + name, value ~ table.item (name))
				end
			end
		end

feature {NONE} -- Implementation

	fragment_string (uri_string: STRING; a_index: INTEGER): STRING
		local
			index: INTEGER
		do
			index := uri_string.index_of ('#', a_index + 1)
			if index > 0 then
				Result := uri_string.substring (index + 1, uri_string.count)
			else
				Result := ""
			end
		end

	path_string (uri_string: STRING; a_index: INTEGER): STRING
		local
			end_index: INTEGER
		do
			across "?#" as delimiter until end_index > 0 loop
				if uri_string.has (delimiter.item) then
					end_index := uri_string.index_of (delimiter.item, a_index + 1) - 1
				end
			end
			if end_index = 0 then
				end_index := uri_string.count
			end
			Result := uri_string.substring (a_index + 1, end_index)
		end

	query_string (uri_string: STRING; index: INTEGER): STRING
		local
			end_index: INTEGER
		do
			if uri_string.has ('?') then
				if uri_string.has ('#') then
					end_index := uri_string.index_of ('#', index + 1) - 1
				else
					end_index := uri_string.count
				end
				Result := uri_string.substring (index + 2, end_index)
			else
				Result := ""
			end
		end

feature {NONE} -- Constants

	Uri_strings: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
				mtp://[usb:003,006]/
				http://myching.software/
				http://myching.software/en/home/my-ching.html
				file:///home/finnian/Desktop
			]")
		end

	Sd_card: ZSTRING
		once
			Result := "SD Card/Music"
		end

	Trade_mark_path: STRING_32
		once
			Result := {STRING_32} "/trade/mark™.txt"
		end

end
