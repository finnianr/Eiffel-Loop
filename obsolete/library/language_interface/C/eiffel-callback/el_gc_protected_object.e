note
	description: "[
		Creates a pointer to an Eiffel object that is temporarily exempted from garbage collection.
		It's position in memory is gauranteed not to move. This is useful for calling Eiffel procedures from a C callback.
		
		When diposed by the the garbage collector it frees the target for collection, so it should be
		declared in a scope allowing it to be garbage collected independantly of the target object.
		
		See also: class [./el_c_callback.html EL_C_CALLBACK]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-28 17:28:05 GMT (Wednesday 28th September 2016)"
	revision: "2"

class
	EL_GC_PROTECTED_OBJECT

inherit
	EL_CALLBACK_C_API
		redefine
			dispose
		end

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

end
