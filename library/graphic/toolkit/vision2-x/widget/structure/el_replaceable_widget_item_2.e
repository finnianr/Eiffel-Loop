note
	description: "Duplicate of [$source EL_REPLACEABLE_WIDGET] for a second class attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-01 9:20:16 GMT (Tuesday 1st September 2020)"
	revision: "2"

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
