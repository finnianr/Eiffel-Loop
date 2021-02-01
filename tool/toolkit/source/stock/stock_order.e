note
	description: "Stock order"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-01 12:40:40 GMT (Monday 1st February 2021)"
	revision: "1"

class
	STOCK_ORDER

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	count: INTEGER

	date: DATE

end