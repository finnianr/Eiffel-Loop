note
	description: "Shared table of [$source ENCODING] objects by `code_page'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 10:14:58 GMT (Friday 11th February 2022)"
	revision: "2"

deferred class
	EL_SHARED_ENCODING_TABLE

inherit
	EL_MODULE

	EL_SHARED_ENCODINGS

feature {NONE} -- Implementation

	new_encoding (code_page: STRING): ENCODING
		do
			if code_page ~ Encodings.Utf_8 then
				Result := Encodings.Utf_8

			elseif code_page ~ Encodings.Utf_16 then
				Result := Encodings.Utf_16

			elseif code_page ~ Encodings.Unicode then
				Result := Encodings.Unicode

			elseif code_page ~ Encodings.Latin_1 then
				Result := Encodings.Latin_1
			else
				create Result.make (code_page)
			end
		end

feature {NONE} -- Constants

	Encoding_table: EL_CACHE_TABLE [ENCODING, STRING]
		once ("PROCESS")
			create Result.make_equal (5, agent new_encoding)
		end
end