note
	description: "[
		Common HTTP text document types
		See [https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:31:24 GMT (Sunday 24th December 2023)"
	revision: "1"

class
	EL_DOC_TEXT_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as eiffel_naming
		end

	EL_ENCODING_TYPE
		export
			{NONE} all
		end

create
	make

feature -- Keywords

	calendar: NATURAL_8

	CSS: NATURAL_8

	CSV: NATURAL_8

	HTML: NATURAL_8

	javascript: NATURAL_8

	plain: NATURAL_8

	XML: NATURAL_8

end