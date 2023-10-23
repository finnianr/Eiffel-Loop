note
	description: "[
		Fixes an Eiffel object in memory so that it can be the target of callbacks from a
		C routine. The garbage collector is prevented from moving it during collect cycles.
	]"
	instructions: "[
		Use this class by making a call to the `new_callback' function in a descendant of class
		[$source EL_C_CALLABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-06 17:56:01 GMT (Friday 6th October 2023)"
	revision: "6"

deferred class
	EL_CALLBACK_FIXER_I

inherit
	EL_C_API_ROUTINES

	EL_MEMORY

feature {NONE} -- Initialization

	make (target: EL_C_CALLABLE)
			--
		deferred
		end

feature -- Access

	item: POINTER
		-- pointer to object fixed in memory

feature {NONE} -- Implementation

	set_item (target: EL_C_CALLABLE)
		do
			item := eif_freeze (target)
			target.set_fixed_address (item)
		end

feature -- Status change

	release
		do
			eif_unfreeze (item); item := Default_pointer
		end

end