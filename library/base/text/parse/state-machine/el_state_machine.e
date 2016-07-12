note
	description: "Summary description for {EL_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-13 15:46:39 GMT (Tuesday 13th January 2015)"
	revision: "4"

class
	EL_STATE_MACHINE [G]

feature {NONE} -- Initialization

	make
		do
			state := agent final
			create tuple
		end

feature -- Basic operations

	traverse (initial: like state; sequence: LINEAR [G])
			--
		local
			final_state: EL_PROCEDURE
		do
			create final_state.make (agent final)
			from
				sequence.start; state := initial
			until
				sequence.after or final_state.same_procedure (state)
			loop
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

	final (item: G)
			--
		do
		end

	state: PROCEDURE [like Current, TUPLE [G]]

	tuple: TUPLE [G]

end
