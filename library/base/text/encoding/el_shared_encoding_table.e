note
	description: "Shared table of [$source ENCODING] objects by `code_page'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 8:25:13 GMT (Thursday 10th February 2022)"
	revision: "1"

deferred class
	EL_SHARED_ENCODING_TABLE

inherit
	EL_MODULE

feature {NONE} -- Implementation

	new_encoding (code_page: STRING): ENCODING
		do
			create Result.make (code_page)
		end

feature {NONE} -- Constants

	Encoding_table: EL_CACHE_TABLE [ENCODING, STRING]
		once ("PROCESS")
			create Result.make_equal (5, agent new_encoding)
		end
end