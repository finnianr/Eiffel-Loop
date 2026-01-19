note
	description: "Title parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 14:21:03 GMT (Saturday 24th June 2023)"
	revision: "8"

class
	TITLE_PARAMETER

inherit
	VALUE_PARAMETER
		rename
			item as title
		redefine
			display_item
		end

create
	make

feature {NONE} -- Implementation

	display_item
			--
		do
			log.put_new_line
			log.put_curtailed_string_field (type, title, 200)
			log.put_new_line
		end

end