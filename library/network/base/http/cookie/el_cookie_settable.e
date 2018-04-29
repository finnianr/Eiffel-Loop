note
	description: "[
		Object that is reflectively settable from http cookies and also reflectively convertable
		to a list of cookies.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 9:11:47 GMT (Thursday 26th April 2018)"
	revision: "4"

deferred class
	EL_COOKIE_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		end

	EL_SETTABLE_FROM_ZSTRING

feature {NONE} -- Initialization

	make (cookies: EL_HTTP_COOKIE_TABLE)
		do
			make_default
			set_from_table (cookies)
		end

	make_from_file (cookie_path: EL_FILE_PATH)
		do
			make_default
			if cookie_path.exists then
				set_from_table (create {EL_HTTP_COOKIE_TABLE}.make_from_file (cookie_path))
			end
		end

feature -- Element change

	set_from_cookies (cookies: EL_HTTP_COOKIE_TABLE)
		do
			reset_fields
			set_from_table (cookies)
		end

feature -- Conversion

	cookie_list: EL_ARRAYED_LIST [EL_HTTP_COOKIE]
		local
			table: like field_table; cookie: EL_HTTP_COOKIE
		do
			table := field_table
			create Result.make (table.count)
			from table.start until table.after loop
				create cookie.make (table.key_for_iteration, table.item_for_iteration.to_string (Current))
				Result.extend (cookie)
				table.forth
			end
		end

end
