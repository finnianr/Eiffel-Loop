note
	description: "Duplicate of [$source EL_REPLACEABLE_WIDGET_ITEM] for a second class attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:06:01 GMT (Tuesday 7th December 2021)"
	revision: "3"

deferred class
	EL_REPLACEABLE_WIDGET_ITEM_2

inherit
	EL_MODULE_WIDGET

feature {NONE} -- Implementation

	new_item: EV_WIDGET
		deferred
		end

	replace_item
		local
			new: like new_item
		do
			new := new_item
			Widget.replace (item, new)
			item := new
		end

feature {NONE} -- Internal attributes

	item: like new_item

end