note
	description: "Replaceable attribute conforming to [$source EV_WIDGET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 18:16:58 GMT (Tuesday 2nd March 2021)"
	revision: "3"

deferred class
	EL_REPLACEABLE_WIDGET_ITEM

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