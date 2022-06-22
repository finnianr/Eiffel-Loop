note
	description: "XML tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 10:11:30 GMT (Wednesday 22nd June 2022)"
	revision: "2"

class
	XML_TAG

inherit
	EL_MARKUP_TEMPLATES

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (name: READABLE_STRING_GENERAL)
		do
			open := Tag_open #$ [name]
			close := Tag_close #$ [name]
		end

feature -- Access

	close: ZSTRING

	open: ZSTRING

end