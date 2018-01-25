note
	description: "Summary description for {EL_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-14 13:39:28 GMT (Thursday 14th December 2017)"
	revision: "4"

class
	EL_STATE_MACHINE [G]

feature {NONE} -- Initialization

	make
		do
			final := agent (v: G) do end
			state := final
			create tuple
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

	traverse_indexable (initial: like state; indexable: READABLE_INDEXABLE [G])
		local
			l_final: like final; i, upper: INTEGER
		do
			item_number := 0; l_final := final
			upper := indexable.upper
			from i := indexable.lower; state := initial until i > upper or state = l_final loop
				item_number := item_number + 1
				call (indexable [i])
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	call (item: G)
		-- call state procedure with item
		do
			tuple.put (item, 1)
			state.set_operands (tuple)
			state.apply
		end

feature {NONE} -- Internal attributes

	final: like state

	item_number: INTEGER

	state: PROCEDURE [G]

	tuple: TUPLE [G]

end
