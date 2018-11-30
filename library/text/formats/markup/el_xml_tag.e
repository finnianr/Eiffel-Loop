note
	description: "Xml tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-16 20:25:30 GMT (Friday 16th November 2018)"
	revision: "1"

class
	EL_XML_TAG

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
