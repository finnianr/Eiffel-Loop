note
	description: "Uri encoding test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 10:54:24 GMT (Saturday 1st February 2020)"
	revision: "8"

class
	URI_ENCODING_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_TUPLE

	EL_MODULE_LIO

feature -- Test routines

	test_utf_8_sequence
		local
			sequence: EL_UTF_8_SEQUENCE
		do
			create sequence.make
			sequence.set ('€')
			assert ("same string", sequence.to_hexadecimal_escaped ('%%') ~ "%%E2%%82%%AC" )
		end

	test_url_query_string_8
		local
			query_string: EL_URL_QUERY_STRING_8
		do
			create query_string.make (5)
			query_string.append_general ("euro")
			query_string.append_character ('=')
			query_string.append_general ({STRING_32} "€")
			assert ("same_string", query_string.same_string (Euro_uri))
		end

	test_url_query_hash_table
		note
			testing:	"covers/{EL_URL_QUERY_STRING_8}.append_general",
				"covers/{EL_URL_QUERY_STRING_8}.to_utf_8",
				"covers/{EL_URL_QUERY_HASH_TABLE}.make",
				"covers/{EL_URL_QUERY_HASH_TABLE}.url_query_string"
		local
			book: EL_URL_QUERY_ZSTRING_HASH_TABLE
			book_query_string: STRING
		do
			create book.make_equal (3)
			book.set_string_general ("author", Book_info.author)
			book.set_string_general ("price", Book_info.price)
			book.set_string_general ("publisher", "Barnes & Noble")
			book.set_string_general ("discount", Book_info.discount)
			book_query_string := book.url_query_string
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_book))

			create book.make (Encoded_book)
			assert ("valid author", book.item ("author") ~ Book_info.author)
			assert ("valid price", book.item ("price") ~ Book_info.price)
			assert ("valid publisher", book.item ("publisher") ~ Book_info.publisher)
			assert ("valid discount", book.item ("discount") ~ Book_info.discount)
			book_query_string := book.url_query_string
			lio.put_string_field ("book_query_string", book_query_string)
			lio.put_new_line
			assert ("same_string", book_query_string.same_string (Encoded_book))
		end

feature {NONE} -- Constants

	Book_info: TUPLE [author, price, publisher, discount: ZSTRING]
		once
			create Result
			Tuple.fill (Result, {STRING_32} "Günter (Wilhelm) Grass, € 10.00, Barnes & Noble, 10%%")
			assert ("price correct", Result.price.same_string ({STRING_32} "€ 10.00"))
		end

	Encoded_book: STRING = "[
		author=G%C3%BCnter+%28Wilhelm%29+Grass&price=%E2%82%AC+10.00&publisher=Barnes+%26+Noble&discount=10%25
	]"

	Euro_uri: STRING = "[
		euro=%E2%82%AC
	]"

	Uri_string: EL_URI_STRING_8
		once
			create Result.make_empty
		end
end
