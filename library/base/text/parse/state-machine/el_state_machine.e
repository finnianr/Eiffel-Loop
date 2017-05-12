note
	description: "Summary description for {EL_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-26 12:03:38 GMT (Wednesday 26th April 2017)"
	revision: "2"

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

feature {NONE} -- Implementation

	call (item: G)
		-- call state procedure with item
		do
			tuple.put_reference (item, 1)
			state.set_operands (tuple)
			state.apply
		end

feature {NONE} -- Internal attributes

	final: like state

	item_number: INTEGER

	state: PROCEDURE [like Current, TUPLE [G]]

	tuple: TUPLE [G]

end
