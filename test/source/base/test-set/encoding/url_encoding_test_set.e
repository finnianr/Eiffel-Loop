note
	description: "Uri encoding test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-10 10:35:03 GMT (Wednesday 10th February 2021)"
	revision: "12"

class
	URL_ENCODING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

	ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("url_query_part",			agent test_url_query_part)
			eval.call ("utf_8_sequence",			agent test_utf_8_sequence)
			eval.call ("url_query_hash_table",	agent test_url_query_hash_table)
		end

feature -- Test

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

	Currency_symbols: STRING_32
		once
			Result := {STRING_32} "$£€"
			Result.append_code (0x20731)
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
			assert ("price correct", Book_info.price.same_string ({STRING_32} "€ 10.00"))

			create book.make_equal (book_table.count)
			across Book_table as info loop
				book.set_name_value (info.key, info.item)
			end

			book_query_string := book.url_query
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_book))

			create book.make_url (Encoded_book)
			across Book_table as info loop
				assert ("valid " + info.key, book.item (info.key) ~ info.item)
			end
			book_query_string := book.url_query
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_book))
		end

	test_utf_8_sequence
		local
			sequence: EL_UTF_8_SEQUENCE
		do
			create sequence.make
			sequence.set ('€')
			assert ("same string", sequence.to_hexadecimal_escaped ('%%') ~ "%%E2%%82%%AC" )
		end

feature {NONE} -- Constants

	Uri_string: EL_URI_QUERY_STRING_8
		once
			create Result.make_empty
		end
end