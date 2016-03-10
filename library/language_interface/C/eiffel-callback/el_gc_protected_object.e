note
	description: "[
		Creates a pointer to an Eiffel object that is temporarily exempted from garbage collection.
		It's position in memory is gauranteed not to move. This is useful for calling Eiffel procedures from a C callback.
		
		When diposed by the the garbage collector it frees the target for collection, so it should be
		declared in a scope allowing it to be garbage collected independantly of the target object.
		
		See also: class EL_C_CALLBACK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_GC_PROTECTED_OBJECT

inherit
	EL_MEMORY
		export
			{NONE} all
		redefine
			dispose
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (object: ANY)
			--
		do
			collector_status := collecting
			set_collection_on
			item := c_eif_freeze (object)
			is_protected := True
			restore_collector_status
		end

feature -- Status query

	is_protected: BOOLEAN
		-- Is object protected from garbage collection

feature -- Access

	item: POINTER
		-- pointer to uncollectable object

feature -- Status change

	unprotect
			--
		do
			set_collection_on
			c_eif_unfreeze (item)
			restore_collector_status
			is_protected := false
		end

feature {NONE} -- Implementation

	set_collection_on
			--
		do
			if collector_status = false then
				collection_on
			end
		ensure
			is_collecting: collecting
		end

	 restore_collector_status
			--
		require
			is_collecting: collecting
		do
			if collector_status = false then
				collection_off
			end
		ensure
			status_restored: collector_status = collecting
		end

	dispose
			--
		do
			if is_protected then
				unprotect
			end
		end

	collector_status: BOOLEAN

feature {NONE} -- C Externals

	c_eif_freeze (obj: ANY): POINTER
			-- Undocumented routine
			-- Prevents garbaged collector from moving object
		require
			obj_not_void: obj /= void
		external
			"c [macro <eif_eiffel.h>] (EIF_OBJECT): EIF_REFERENCE"
		alias
			"eif_freeze"
		end

	c_eif_unfreeze (ptr: POINTER)
			-- Undocumented routine
			-- Allows object to be moved by the gc now.
		require
			ptr_attached: is_attached (ptr)
		external
			"c [macro <eif_eiffel.h>] (EIF_REFERENCE)"
		alias
			"eif_unfreeze"
		end

end
