note
	description: "Stock order"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:34:47 GMT (Thursday 16th June 2022)"
	revision: "2"

class
	STOCK_ORDER

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Access

	count: INTEGER

	date: DATE

end