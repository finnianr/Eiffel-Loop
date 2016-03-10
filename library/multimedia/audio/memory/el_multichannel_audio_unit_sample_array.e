note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MULTICHANNEL_AUDIO_UNIT_SAMPLE_ARRAY [N -> NUMERIC]

inherit
	ARRAY [EL_SUBARRAY [N]]
		redefine
			put, enter, force
		end

create
	make

feature -- Access

	sample_count: INTEGER
			--
		do
			if item (1) = Void then
				Result := 0
			else
				Result := item (1).count
			end
		end

	sample_interval: INTEGER_INTERVAL
			--
		do
			if item (1) = Void then
				Result := 0 |..| 0
			else
				create Result.make (item (1).lower, item (1).upper)
			end
		end

feature -- Element change

	put (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		require else
			valid_item_dimensions: valid_item_dimensions (v, i)
		do
			Precursor (v, i)
		end

	enter (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		require else
			valid_item_dimensions: valid_item_dimensions (v, i)
		do
			Precursor (v, i)
		end

	force (v: like item; i: INTEGER)
			-- Assign item `v' to `i'-th entry.
			-- Always applicable: resize the array if `i' falls out of
			-- currently defined bounds; preserve existing items.
		require else
			valid_item_dimensions: valid_item_dimensions (v, i)
		do
			Precursor (v, i)
		end

feature -- Contract support

	valid_item_dimensions (v: like item; i: INTEGER): BOOLEAN
			--
		do
			Result := i > 1 and item (1) /= Void implies
				item (1).count = v.count and item (1).lower = v.lower and item (1).upper = v.upper

		end

end
