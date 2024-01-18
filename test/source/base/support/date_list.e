note
	description: "${DATE} objects stored as list of ${INTEGER} numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-20 14:47:50 GMT (Monday 20th November 2023)"
	revision: "1"

class
	DATE_LIST

inherit
	EL_ARRAYED_REPRESENTATION_LIST [DATE, INTEGER]
		rename
			seed_item as compact_item,
			to_seed as to_compact_date,
			to_representation as to_date
		end

create
	make

feature -- Conversion

	to_date (compact_date: INTEGER): DATE
		do
			create Result.make_by_ordered_compact_date (compact_date)
		end

	to_compact_date (date: DATE): INTEGER
		do
			Result := date.ordered_compact_date
		end

end