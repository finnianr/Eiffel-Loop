note
	description: "Encoding constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 18:19:03 GMT (Thursday 28th May 2020)"
	revision: "1"

deferred class
	ENCODING_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Currency_list: EL_STRING_8_LIST
		once
			create Result.make_with_csv ("[
				%24, %C2%A3, %E2%82%AC, %F0%A0%9C%B1
			]")
		end

	Book_info: TUPLE [author, price, publisher, discount: ZSTRING]
		once
			create Result
			Tuple.fill (Result, {STRING_32} "Günter (Wilhelm) Grass, € 10.00, Barnes & Noble, 10%%")
		end

	Book_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make (<<
				["author", Book_info.author],
				["price", Book_info.price],
				["publisher", Book_info.publisher],
				["discount", Book_info.discount]
			>>)
		end

	Encoded_book: STRING = "[
		author=G%C3%BCnter+%28Wilhelm%29+Grass&price=%E2%82%AC+10.00&publisher=Barnes+%26+Noble&discount=10%25
	]"

end
