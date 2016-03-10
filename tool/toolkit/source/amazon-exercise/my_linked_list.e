note
	description: "Amazon exercise in linked list reversal"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	MY_LINKED_LIST [G]

feature -- Access

	item: G
		-- Current item for iteration
		do
			Result := cursor.item
		end

	count: INTEGER

	index: INTEGER
		-- cursor index

feature -- Status query

	after: BOOLEAN
			-- cursor is after last element
		do
			Result := index = count + 1
		end

feature -- Iteration

	forth
			-- Move cursor to next postion
		do
			if cursor.has_right then
				cursor := cursor.right
			end
			index := index + 1
		end

	start
			-- Move cursor to first postion if any
		do
			index := 1
			if not after then
				create cursor.make (first.item)
				cursor.set_right (first.right)
			end
		end

feature -- Element change

	extend (v: like item)
			--
		local
			new_node: like first
		do
			create new_node.make (v)
			if count = 0 then
				first := new_node
				last := new_node
			else
				last.set_right (new_node)
				last := new_node
			end
			count := count + 1
		end

feature -- Transformation

	reverse
			-- non recursive element order reverse
		local
			reversed: ARRAY [like item]
			i: INTEGER
		do
			create reversed.make (1, count)
			from start until after loop
				reversed [count + 1 - index] := item
				forth
			end
			wipeout
			from i := 1 until i > reversed.upper loop
				extend (reversed [i])
				i := i + 1
			end
		end

	reverse_recursively
			-- recursive element order reverse
		local
			l_first: like first
		do
			l_first := first
			if count > 0 then
				wipeout
				append_in_reverse (l_first)
			end
		end

feature -- Removal

	wipeout
			--
		do
			count := 0
			first := Void
			last := Void
		end

feature {NONE} -- Implementation

	append_in_reverse (node: like first)
			--
		do
			if node.has_right then
				append_in_reverse (node.right)
			end
			extend (node.item)
		end

	first: NODE_LINK [like item]

	last: like first

	cursor: like first

end
