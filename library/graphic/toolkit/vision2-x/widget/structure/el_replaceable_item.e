note
	description: "Replaceable attribute conforming to `EV_ITEM'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 14:59:01 GMT (Monday 31st August 2020)"
	revision: "1"

deferred class
	EL_REPLACEABLE_ITEM

inherit
	EL_MODULE_WIDGET

feature {NONE} -- Implementation

	new_item: EV_ITEM
		deferred
		end

	replace_item
		local
			new: like new_item
		do
			new := new_item
			Widget.replace_item (item, new)
			item := new
		end

feature {NONE} -- Internal attributes

	item: like new_item

end
