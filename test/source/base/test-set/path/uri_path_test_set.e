note
	description: "URI path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 5:35:39 GMT (Monday 25th May 2020)"
	revision: "7"

class
	URI_PATH_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_URL

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("uri_make", agent test_uri_make)
			if fALSE then
				eval.call ("decode_url", agent test_decode_url)
				eval.call ("directory_join", agent test_directory_join)
				eval.call ("uri_assignments", agent test_uri_assignments)
			end
		end

feature -- Tests

	test_decode_url
		local
			uri: EL_DIR_URI_PATH; nvp: EL_NAME_VALUE_PAIR [ZSTRING]
			parts: EL_STRING_8_LIST
		do
			across Currency_list as list loop
				create parts.make_with_separator (list.item, '?', False)
				uri := parts.first
				assert ("reversible", uri.to_encoded_utf_8 ~ parts.first)
				create nvp.make (URL.decoded_path (parts.last), '=')
				inspect list.cursor_index
					when 1 then
						assert ("Dollor", nvp.value [1] = '$')
					when 2 then
						assert ("Pound", nvp.value [1] = '£')
					when 3 then
						assert ("Euro", nvp.value [1] = '€')
					when 4 then
						assert ("Han character (to peel)", nvp.value [1] = (0x20731).to_character_32)
				else
				end
			end
		end

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

	test_uri_make
		local
			uri: EL_URI; scheme, authority, path, query, s, base_uri, uri_string, fragment: STRING
			end_index, index: INTEGER
		do
			across << "foo://example.com:8042/over/there", "file:///trade/mark%%E2%%84%%A2.txt" >> as list loop
				base_uri := list.item
				across << "", "?name=ferret", "#nose", "?name=ferret#nose" >> as tail loop
					uri_string := base_uri + tail.item
					uri := uri_string
					scheme := uri_string.substring (1, uri_string.index_of (':', 1) - 1)
					assert ("scheme ok", uri.scheme ~ scheme)

					s := scheme + "://"
					authority := uri_string.substring (s.count + 1, uri_string.index_of ('/', s.count + 1) - 1)
					assert ("authority ok", uri.authority ~ authority)

					s := s + authority
					end_index := 0
					across "?#" as delimiter until end_index > 0 loop
						if uri_string.has (delimiter.item) then
							end_index := uri_string.index_of (delimiter.item, s.count + 1) - 1
						end
					end
					if end_index = 0 then
						end_index := uri_string.count
					end
					path := uri_string.substring (s.count + 1, end_index)
					assert ("path ok", uri.path ~ path)
					if path.has_substring ("trade") then
						assert ("same path", uri.to_file_path.as_string_32 ~ {STRING_32} "/trade/mark™.txt")
					end

					s := s + path
					if uri_string.has ('?') then
						if uri_string.has ('#') then
							end_index := uri_string.index_of ('#', s.count + 1) - 1
						else
							end_index := uri_string.count
						end
						query := uri_string.substring (s.count + 2, end_index)
					else
						query := ""
					end
					assert ("query ok", uri.query ~ query)

					if not query.is_empty then
						s := s + "?" + query
					end
					index := uri_string.index_of ('#', s.count + 1)
					if index > 0 then
						fragment := uri_string.substring (index + 1, uri_string.count)
					else
						fragment := ""
					end
					assert ("fragment ok", uri.fragment ~ fragment)
				end
			end
		end

feature {NONE} -- Constants

	Currency_list: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
				http://shop.com/currency.html?symbol=%24
				http://shop.com/currency.html?symbol=%C2%A3
				http://shop.com/currency.html?symbol=%E2%82%AC
				http://shop.com/currency.html?symbol=%F0%A0%9C%B1
			]")
		end

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

end
