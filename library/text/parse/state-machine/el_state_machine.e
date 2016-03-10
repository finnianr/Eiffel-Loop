note
	description: "Summary description for {EL_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 21:28:03 GMT (Tuesday 25th June 2013)"
	revision: "2"

class
	EL_STATE_MACHINE [G]

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
			state.call ([item])
		end

	final (item: G)
			--
		do
		end

	state: PROCEDURE [like Current, TUPLE [G]]

end
