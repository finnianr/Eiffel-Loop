note
	description: "Uri encoding test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	URI_ENCODING_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_url_query_hash_table
		note
			testing:	"covers/{EL_URL_QUERY_STRING_8}.append_general",
				"covers/{EL_URL_QUERY_STRING_8}.to_utf_8",
				"covers/{EL_URL_QUERY_HASH_TABLE}.make",
				"covers/{EL_URL_QUERY_HASH_TABLE}.url_query_string"
		local
			book: EL_URL_QUERY_HASH_TABLE
		do
			create book.make_equal (3)
			book.set_string ("author", Book_info.author)
			book.set_string ("price", Book_info.price)
			book.set_string_general ("publisher", "Barnes & Noble")
			book.set_string_general ("discount", Book_info.discount)
			assert ("same_string", book.url_query_string.same_string (Encoded_book))

			create book.make (Encoded_book)
			assert ("valid author", book.item ("author") ~ Book_info.author)
			assert ("valid price", book.item ("price") ~ Book_info.price)
			assert ("valid discount", book.item ("discount") ~ Book_info.discount)
			assert ("same_string", book.url_query_string.same_string (Encoded_book))
		end

feature {NONE} -- Constants

	Book_info: TUPLE [author, price, publisher, discount: ZSTRING]
		once
			create Result
			Result.author := "Günter (Wilhelm) Grass"
			Result.price := {STRING_32} "€ 10.00"
			Result.discount := "10%%"
		end

	Encoded_book: STRING = "[
		author=G%C3%BCnter+%28Wilhelm%29+Grass&price=%E2%82%AC+10.00&publisher=Barnes+%26+Noble&discount=10%25
	]"

	Uri_string: EL_URI_STRING_8
		once
			create Result.make_empty
		end
end
