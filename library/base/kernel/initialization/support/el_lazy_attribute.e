note
	description: "Detachable object attribute that is created only when needed (lazy evaluation)"
	notes: "[
		More often than not, you can use a once per object routine for lazy evaluation.
		
			object: MY_CLASS
				once ("OBJECT")
					create Result
				end
				
		But in rare cases where you need the ability to reassign the attribute, it makes more sense
		to inherit from this class. For example: ${EL_NAMED_THREAD}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:15:06 GMT (Sunday 10th November 2024)"
	revision: "5"

deferred class
	EL_LAZY_ATTRIBUTE

feature {NONE} -- Implementation

	lazy_item: like new_item
		do
			if attached cached_item as l_item then
				Result := l_item
			else
				Result := new_item
				cached_item := Result
			end
		end

	reset_item
		do
			cached_item := Void
		end

feature {NONE} -- Deferred

	new_item: ANY
		deferred
		end

feature {NONE} -- Internal attributes

	cached_item: detachable like new_item

end
