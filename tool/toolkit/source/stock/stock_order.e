note
	description: "Stock order"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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