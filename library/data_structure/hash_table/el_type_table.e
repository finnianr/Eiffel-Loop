note
	description: "Caches objects associated with a type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-25 11:03:22 GMT (Friday 25th December 2015)"
	revision: "4"

class
	EL_TYPE_TABLE [G]

inherit
	HASH_TABLE [G, TYPE [ANY]]
		rename
			item as cached_item
		end

create
	make_equal

feature -- Access

	item (type: like key_for_iteration; new_item: FUNCTION [ANY, TUPLE, like cached_item]): like cached_item
			-- Returns a `new_item' or else the `cached_item' for the `type'
		do
			search (type)
			if found then
				Result := found_item
			else
				Result := new_item.item ([])
				extend (Result, type)
			end
		end

end
