note
	description: "[
		Object with a target callable from C. 
		The target is temporarily fixed in memory and guaranteed not to be moved by the garbage collector.
		When the gc_protector object is collected it releases the target for collection.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_C_TO_EIFFEL_CALLBACK_STRUCT [TARGET -> EL_C_CALLABLE create make end]

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create target.make
			create gc_protector.make (target)
			target.set_gc_protected_callbacks_target (gc_protector)
		end

feature -- Access

	item: POINTER
			--
		do
			Result := target.pointer_to_c_callbacks_struct
		end

feature {NONE} -- Implementation

	target: TARGET
		-- Call back target object

	gc_protector: EL_GC_PROTECTED_OBJECT
		-- Stops target from being moved by garbage collector

end
