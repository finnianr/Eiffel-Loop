note
	description: "Cached string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_CACHED_STRING [STR -> READABLE_STRING_GENERAL create make_empty end]

create
	make

feature {NONE} -- Initialization

	make (a_fn_new_item: like fn_new_item)
		do
			fn_new_item := a_fn_new_item
			create last_item.make_empty
			enable
		end

feature -- Access

	item: STR
		do
			if not is_enabled or else last_item.is_empty then
				fn_new_item.apply
				last_item := fn_new_item.last_result
			end
			Result := last_item
		end

feature -- Basic operations

	clear
		do
			create last_item.make_empty
		end

feature -- Status query

	is_enabled: BOOLEAN

feature -- Status setting

	disable
			-- disable caching
		do
			is_enabled := False
		end

	enable
			--enable caching
		do
			is_enabled := True
		end

feature {NONE} -- Implementation

	last_item: like item

	fn_new_item: FUNCTION [STR]

end