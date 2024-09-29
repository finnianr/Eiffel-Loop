note
	description: "[
		Common HTTP text document types
		See [https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:48:14 GMT (Saturday 28th September 2024)"
	revision: "4"

class
	EL_DOC_TEXT_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as eiffel_naming
		end

	EL_ENCODING_TYPE
		export
			{NONE} all
			{ANY} valid_encoding
		end

create
	make

feature -- Access

	type_and_encoding (doc_type: NATURAL_8; encoding: NATURAL): NATURAL
		require
			valid_type: valid_value (doc_type)
			valid_encoding: valid_encoding (encoding)
		do
			Result := (doc_type.to_natural_32 |<< 16) | encoding
		end

feature -- Keywords

	CSS: NATURAL_8

	CSV: NATURAL_8

	HTML: NATURAL_8

	XML: NATURAL_8

	calendar: NATURAL_8

	javascript: NATURAL_8

	plain: NATURAL_8

end