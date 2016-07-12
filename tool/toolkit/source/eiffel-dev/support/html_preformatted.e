note
	description: "Summary description for {HTML_PREFORMATTED}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 6:50:05 GMT (Tuesday 5th July 2016)"
	revision: "6"

class
	HTML_PREFORMATTED

inherit
	HTML_PARAGRAPH
		redefine
			is_preformatted
		end

create
	make

feature -- Status query

	is_preformatted: BOOLEAN
		do
			Result := True
		end
end
