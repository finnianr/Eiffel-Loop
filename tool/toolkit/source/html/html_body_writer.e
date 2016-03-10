note
	description: "Summary description for {HTML_BODY_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

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
