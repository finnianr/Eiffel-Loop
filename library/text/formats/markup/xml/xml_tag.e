note
	description: "XML tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:22:07 GMT (Sunday 1st January 2023)"
	revision: "4"

class
	XML_TAG

inherit
	ANY

	EL_MARKUP_TEMPLATES

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (name: READABLE_STRING_GENERAL)
		do
			open := Tag.open #$ [name]
			close := Tag.close #$ [name]
		end

feature -- Access

	close: ZSTRING

	open: ZSTRING

end