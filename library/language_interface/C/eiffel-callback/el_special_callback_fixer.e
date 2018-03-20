note
	description: "[
		Fixes an Eiffel object in memory so that it can be the target of callbacks from a
		C routine. This is same as class [$source EL_CALLBACK_FIXER] except it assumes the garbage collector has
		been disabled.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:14:55 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_SPECIAL_CALLBACK_FIXER

inherit
	EL_CALLBACK_FIXER_I
		redefine
			make, release
		end

create
	make

feature {NONE} -- Initialization

	make (target: EL_C_CALLABLE)
			--
		require else
			garbage_collection_disabled: not collecting
		do
			collection_on
			set_item (target)
			collection_off
		end

feature -- Status change

	release
		do
			collection_on
			Precursor
			collection_off
		end

end
