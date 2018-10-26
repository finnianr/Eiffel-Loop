note
	description: "Html body writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 13:26:21 GMT (Thursday 27th September 2018)"
	revision: "4"

class
	EL_HTML_BODY_WRITER

inherit
	EL_HTML_WRITER

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
