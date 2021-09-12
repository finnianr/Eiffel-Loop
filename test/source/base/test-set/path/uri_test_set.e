note
	description: "URI test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-11 15:43:15 GMT (Saturday 11th September 2021)"
	revision: "9"

class
	URI_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("uri_assignments", agent test_uri_assignments)
			eval.call ("uri_directory_join", agent test_uri_directory_join)
			eval.call ("url", agent test_url)
			eval.call ("url_parts", agent test_url_parts)
			eval.call ("url_query_hash_table", agent test_url_query_hash_table)
			eval.call ("url_query_part", agent test_url_query_part)
			eval.call ("utf_8_sequence", agent test_utf_8_sequence)
		end

feature -- Tests

	test_uri_assignments
		local
			uri: EL_DIR_URI_PATH; str_32: STRING_32
		do
			across URI_list as line loop
				str_32 := line.item.to_string_32
				create uri.make (str_32)
				assert ("str_32 same as uri.to_string", str_32 ~ uri.to_string.to_string_32)
			end
		end

	test_uri_directory_join
		local
			joined_dir: EL_DIR_PATH; root: EL_DIR_URI_PATH
			joined: ZSTRING
		do
			joined := URI_list [1]
			root := joined
			joined_dir := root.joined_dir_path (sd_card)
			joined.append (SD_card)
			assert ("", joined_dir.to_string ~ joined)
		end

	test_url
		local
			book_info: like new_book_info
			url_string: ZSTRING; url: EL_URL
			encoded_author_title, title_fragment: STRING; s: EL_STRING_8_ROUTINES
		do
			book_info := new_book_info (Gunter_grass)
			url_string := Amazon_query
			create url.make_from_general (url_string)
			assert ("same string", url_string.same_string (url))

			url_string.append_character ('?')
			url_string.append_string_general (Field.author_title)
			url_string.append_character ('=')
			url_string.append_string (book_info.author_title)
			create url.make_from_general (url_string)

			encoded_author_title := s.substring_to (Encoded_gunter_grass, '&', Void)
			assert ("same string", (Amazon_query + "?" + encoded_author_title).same_string (url))

			title_fragment := "#title"
			url_string.append_string_general (title_fragment)
			create url.make_from_general (url_string)
			assert ("same string", (Amazon_query + "?" + encoded_author_title + title_fragment).same_string (url))
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

				if attached new_book_table (Gunter_grass) as book_table then
					url.set_query_from_table (book_table)
					table := url.query_table
					assert ("same count", table.count = book_table.count)
					across book_table as t loop
						name := t.key; value := t.item
						assert ("valid " + name, value ~ table.item (name))
					end
				end
			end
		end

	test_url_query_hash_table
		note
			testing:	"covers/{EL_URI_QUERY_STRING_8}.append_general",
						"covers/{EL_URI_QUERY_STRING_8}.to_utf_8",
						"covers/{EL_URI_QUERY_HASH_TABLE}.make_url",
						"covers/{EL_URI_QUERY_HASH_TABLE}.url_query"
		local
			book: EL_URI_QUERY_ZSTRING_HASH_TABLE; book_query_string: STRING
		do
			if attached new_book_info (Gunter_grass) as book_info then
				assert ("price correct", book_info.price.same_string ({STRING_32} "€ 10.00"))
			end

			if attached new_book_table (Gunter_grass) as book_table then
				create book.make_equal (book_table.count)
				across book_table as info loop
					book.set_name_value (info.key, info.item)
				end
			end

			book_query_string := book.url_query
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_gunter_grass))

			create book.make_url (Encoded_gunter_grass)
			across new_book_table (Gunter_grass) as info loop
				assert ("valid " + info.key, book.item (info.key) ~ info.item)
			end
			book_query_string := book.url_query
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_gunter_grass))
		end

	test_url_query_part
		local
			url: EL_URL; currency_uri: EL_URI_STRING_8
			symbol_32: STRING_32
		do
			across Currency_symbols as symbol loop
				symbol_32 := Currency_symbols.substring (symbol.cursor_index, symbol.cursor_index)

				create currency_uri.make (10)
				currency_uri.append_general (symbol_32)
				assert ("same sequence", Currency_list.i_th (symbol.cursor_index).same_string (currency_uri))
				url := "http://shop.com/currency.html?symbol=" + currency_uri
				assert ("same string", symbol_32 ~ url.query_table.item ("symbol").to_string_32)
			end
		end

	test_utf_8_sequence
		local
			sequence: EL_UTF_8_SEQUENCE
		do
			create sequence.make
			sequence.set ('€')
			assert ("same string", sequence.to_hexadecimal_escaped ('%%') ~ "%%E2%%82%%AC" )
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

	new_book_info (list: READABLE_STRING_GENERAL): TUPLE [author_title, price, publisher, discount: ZSTRING]
		do
			create Result
			Tuple.fill (Result, list)
		end

	new_book_table (list: READABLE_STRING_GENERAL): EL_STRING_HASH_TABLE [ZSTRING, STRING]
		local
			book: like new_book_info
		do
			book := new_book_info (list)
			create Result.make (<<
				[Field.author_title,	book.author_title],
				[Field.price,			book.price],
				[Field.publisher,		book.publisher],
				[Field.discount,		book.discount]
			>>)
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

	Amazon_query: STRING = "http://www.amazon.com/query"

	Currency_list: EL_STRING_8_LIST
		once
			create Result.make_with_csv ("[
				%24, %C2%A3, %E2%82%AC, %F0%A0%9C%B1
			]")
		end

	Encoded_gunter_grass: STRING = "[
		author_title=G%C3%BCnter+(Wilhelm)+Grass/The+Tin+Drum&price=%E2%82%AC+10.00&publisher=Barnes+%26+Noble&discount=10%25
	]"

	Currency_symbols: STRING_32
		once
			Result := {STRING_32} "$£€"
			Result.append_code (0x20731)
		end

	Field: TUPLE [author_title, price, publisher, discount: STRING]
		do
			create Result
			Tuple.fill (Result, "author_title, price, publisher, discount")
		end

	Gunter_grass: STRING_32
		once
			Result := {STRING_32} "Günter (Wilhelm) Grass/The Tin Drum, € 10.00, Barnes & Noble, 10%%"
		end

	SD_card: ZSTRING
		once
			Result := "SD Card/Music"
		end

	Trade_mark_path: STRING_32
		once
			Result := {STRING_32} "/trade/mark™.txt"
		end

	URI_list: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
				mtp://[usb:003,006]/
				http://myching.software/
				http://myching.software/en/home/my-ching.html
				file:///home/finnian/Desktop
			]")
		end

	Uri_query_string: EL_URI_QUERY_STRING_8
		once
			create Result.make_empty
		end

end