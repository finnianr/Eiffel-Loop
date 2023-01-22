note
	description: "[
		Sequence of [$source INTEGER_32] intervals (compressed as [$source INTEGER_64]'s for better performance)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-22 17:01:12 GMT (Sunday 22nd January 2023)"
	revision: "3"

class
	EL_ARRAYED_INTERVAL_LIST

inherit
	EL_ARRAYED_LIST [INTEGER_64]
		rename
			extend as item_extend,
			replace as item_replace,
			put_i_th as put_i_th_interval
		redefine
			out
		end

create
	make, make_empty

feature -- Access

	first_count: INTEGER
		local
			l_first: like first
		do
			l_first := first
			Result := upper_integer (l_first) - lower_integer (l_first) + 1
		end

	first_lower: INTEGER
		do
			Result := lower_integer (first)
		end

	first_upper: INTEGER
		do
			Result := upper_integer (first)
		end

	i_th_lower (i: INTEGER): INTEGER
		do
			Result := lower_integer (i_th (i))
		end

	i_th_upper (i: INTEGER): INTEGER
		do
			Result := upper_integer (i_th (i))
		end

	item_count: INTEGER
		local
			l_item: like item
		do
			l_item := item
			Result := upper_integer (l_item) - lower_integer (l_item) + 1
		end

	item_interval: INTEGER_INTERVAL
		do
			Result := item_lower |..| item_upper
		end

	item_lower: INTEGER
		do
			Result := lower_integer (item)
		end

	item_upper: INTEGER
		do
			Result := upper_integer (item)
		end

	last_count: INTEGER
		local
			l_last: like last
		do
			l_last := last
			Result := upper_integer (l_last) - lower_integer (l_last) + 1
		end

	last_lower: INTEGER
		do
			Result := lower_integer (last)
		end

	last_upper: INTEGER
		do
			Result := upper_integer (last)
		end

	out: STRING
		local
			l_area: like area; i, l_count: INTEGER; l_item: like item
		do
			create Result.make (8 * count)
			l_area := area; l_count := l_area.count
			from until i = l_count loop
				l_item := l_area [i]
				if not Result.is_empty then
					Result.append (", ")
				end
				Result.append_character ('[')
				Result.append_integer (lower_integer (l_item))
				Result.append_character (':')
				Result.append_integer (upper_integer (l_item))
				Result.append_character (']')
				i := i + 1
			end
		end

feature -- Measurement

	count_sum: INTEGER
		local
			l_area: like area; i, l_count: INTEGER; l_item: like item
		do
			l_area := area; l_count := l_area.count
			from until i = l_count loop
				l_item := l_area [i]
				Result := Result + upper_integer (l_item) - lower_integer (l_item) + 1
				i := i + 1
			end
		end

feature -- Status query

	item_has (n: INTEGER): BOOLEAN
		local
			l_item: like item
		do
			l_item := item
			Result := lower_integer (l_item) <= n and then n <= upper_integer (l_item)
		end

feature -- Element change

	extend (a_lower, a_upper: INTEGER)
		do
			item_extend (new_item (a_lower, a_upper))
		ensure
			lower_extended: a_lower = last_lower
			upper_extended: a_upper = last_upper
		end

	extend_upper (a_upper: INTEGER)
		local
			l_last: like last
		do
			if is_empty then
				extend (a_upper, a_upper)
			else
				l_last := last
				if upper_integer (l_last) + 1 = a_upper then
					finish; item_replace (l_last + 1)
				else
					extend (a_upper, a_upper)
				end
			end
		end

	put_i_th (a_lower, a_upper, i: INTEGER)
		require
			valid_index: valid_index (i)
		do
			put_i_th_interval (a_lower.to_integer_64 |<< 32 | a_upper, i)
		end

	replace (a_lower, a_upper: INTEGER)
		do
			item_replace (a_lower.to_integer_64 |<< 32 | a_upper)
		end

feature -- Factory

	new_item (a_lower, a_upper: INTEGER): like item
		do
			Result := a_lower.to_integer_64 |<< 32 | a_upper
		end

feature {NONE} -- Implementation

	lower_integer (a_item: like item): INTEGER
		do
			Result := (a_item |>> 32).to_integer_32
		end

	upper_integer (a_item: like item): INTEGER
		do
			Result := a_item.to_integer_32
		end

end