note
	description: "State machine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-21 11:21:28 GMT (Tuesday 21st December 2021)"
	revision: "11"

class
	EL_STATE_MACHINE [G]

feature {NONE} -- Initialization

	make
		do
			final := agent (v: G) do end
			state := final
		end

feature -- Basic operations

	traverse (initial: like state; sequence: LINEAR [G])
			--
		local
			l_final: like final
		do
			item_number := 0; l_final := final
			from sequence.start; state := initial until sequence.after or state = l_final loop
				item_number := item_number + 1
				call (sequence.item)
				sequence.forth
			end
		end

	traverse_iterable (initial: like state; sequence: ITERABLE [G])
			--
		local
			l_final: like final
		do
			item_number := 0; l_final := final
			state := initial
			across sequence as seq until state = l_final loop
				item_number := item_number + 1
				call (seq.item)
			end
		end

feature {NONE} -- Implementation

	call (item: G)
		-- call state procedure with item
		do
			state (item)
		end

feature {NONE} -- Internal attributes

	final: like state

	item_number: INTEGER

	state: PROCEDURE [G]

end