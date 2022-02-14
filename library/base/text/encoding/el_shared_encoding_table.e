note
	description: "Shared table of [$source ENCODING] objects by `code_page'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:45:44 GMT (Monday 14th February 2022)"
	revision: "3"

deferred class
	EL_SHARED_ENCODING_TABLE

inherit
	EL_MODULE

	EL_SHARED_ENCODINGS

feature {NONE} -- Implementation

	new_encoding (name: STRING): ENCODING
		do
			create Result.make (name)
		end

feature {NONE} -- Constants

	Encoding_table: EL_CACHE_TABLE [ENCODING, STRING]
		once
			create Result.make_equal (5, agent new_encoding)
			across Encodings.standard as encoding loop
				Result.extend (encoding.item, encoding.item.code_page)
			end
		end
end