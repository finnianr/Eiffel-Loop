note
	description: "[
		A second object attribute that is created only if it is needed.
		This is a duplicate of [$source EL_LAZY_ATTRIBUTE] to solve any inheritance conflict.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-04 11:05:47 GMT (Tuesday 4th August 2020)"
	revision: "2"

deferred class
	EL_LAZY_ATTRIBUTE_2

feature -- Access

	item: like new_item
		do
			if attached actual_item_2 as obj then
				Result := obj
			else
				Result := new_item
				actual_item_2 := Result
			end
		end

feature {NONE} -- Implementation

	new_item: ANY
		deferred
		end

	actual_item_2: detachable like new_item
		-- actual created instance
		-- typically this is not renamed in descendant so suffixed with `_2'
		-- to prevent name clash with `{EL_LAZY_ATTRIBUTE}.actual_item'
end
