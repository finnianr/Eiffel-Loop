note
	description: "Shared document types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "11"

deferred class
	EL_SHARED_DOCUMENT_TYPES

inherit
	EL_ENCODING_CONSTANTS
		rename
			Other as Other_class,
			Latin as Latin_class,
			Utf as Utf_class,
			Windows as Windows_class
		end

feature {NONE} -- Constants

	Doc_type_html_utf_8: EL_DOC_TYPE
		once
			create Result.make ("html", Utf_8)
		end

	Doc_type_plain_latin_1: EL_DOC_TYPE
		once
			create Result.make ("plain", Latin_1)
		end

	Doc_type_plain_utf_8: EL_DOC_TYPE
		once
			create Result.make ("plain", Utf_8)
		end

	Doc_type_xml_utf_8: EL_DOC_TYPE
		once
			create Result.make ("xml", Utf_8)
		end

end