note
	description: "Map an object item to a [$source NATURAL_64] value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 10:40:25 GMT (Saturday 18th November 2023)"
	revision: "1"

class
	EL_MAP_TO_NATURAL_64 [G]

feature -- Access

	item: detachable G

	value: NATURAL_64

feature -- Element change

	set_item (a_item: like item)
		do
			item := a_item
		end

	set_value (a_value: NATURAL_64)
		do
			value := a_value
		end

end