note
	description: "Summary description for {HTML_BODY_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

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