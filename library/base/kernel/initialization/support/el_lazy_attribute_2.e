note
	description: "[
		A second object attribute that is created only if it is needed.
		This is a duplicate of ${EL_LAZY_ATTRIBUTE} to solve any inheritance conflict.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:15:26 GMT (Sunday 10th November 2024)"
	revision: "6"

deferred class
	EL_LAZY_ATTRIBUTE_2

feature {NONE} -- Implementation

	lazy_item_2: like new_item
		do
			if attached cached_item_2 as obj then
				Result := obj
			else
				Result := new_item
				cached_item_2 := Result
			end
		end

	reset_item_2
		do
			cached_item_2 := Void
		end

feature {NONE} -- Deferred

	new_item: ANY
		deferred
		end

feature {NONE} -- Internal attributes

	cached_item_2: detachable like new_item
		-- actual created instance
		-- typically this is not renamed in descendant so suffixed with `_2'
		-- to prevent name clash with `{EL_LAZY_ATTRIBUTE}.actual_item'

end