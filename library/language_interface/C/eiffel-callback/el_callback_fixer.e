note
	description: "[
		Fixes an Eiffel object in memory so that it can be the target of callbacks from a
		C routine. The garbage collector is prevented from moving it during collect cycles.
	]"
	instructions: "[
		Use this class by making a call to the `new_callback' function in a descendant of 
		class [$source EL_C_CALLABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_CALLBACK_FIXER

inherit
	EL_CALLBACK_FIXER_I
		redefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make (target: EL_C_CALLABLE)
			--
		require else
			garbage_collection_enabled: collecting
		do
			set_item (target)
		end

feature {NONE} -- Implementation

	dispose
			-- This is incase you forgot to call `release' after invoking the C routine
			-- that does callbacks
		do
			if is_attached (item) then
				c_eif_unfreeze (item)
			end
		end

end