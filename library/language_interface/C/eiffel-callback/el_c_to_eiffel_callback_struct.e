note
	description: "[
		Object with a target callable from C. The target is temporarily fixed in memory and
		guaranteed not to be moved by the garbage collector.When the gc_protector object is
		collected it releases the target for collection.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_C_TO_EIFFEL_CALLBACK_STRUCT [TARGET -> EL_C_CALLABLE create make end]

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create target.make
			callback := target.new_callback
		end

feature -- Access

	target: TARGET
		-- Call back target object

feature {NONE} -- Implementation

	callback: like target.new_callback
		-- Stops target from being moved by garbage collector

end
