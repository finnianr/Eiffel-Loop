note
	description: "Html body writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	HTML_BODY_WRITER

inherit
	HTML_WRITER

create
	make

feature {NONE} -- Implementation

	delimiting_pattern: like one_of
			--
		do
			Result := one_of (<<
				trailing_line_break,
				empty_tag_set,
				preformat_end_tag,
				anchor_element_tag,
				image_element_tag
			>>)
		end

end