note
	description: "State machine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 9:27:03 GMT (Wednesday 14th November 2018)"
	revision: "8"

class
	EL_STATE_MACHINE [G]

inherit
	EL_ROUTINE_APPLICATOR [G]
		export
			{NONE} all
		redefine
			make
		end

feature {NONE} -- Initialization

	make
		do
			Precursor
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
				apply (state, sequence.item)
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
				apply (state, indexable [i])
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	final: like state

	item_number: INTEGER

	state: PROCEDURE [G]

end
