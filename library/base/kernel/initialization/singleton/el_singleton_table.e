note
	description: "Thread safe table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:45:22 GMT (Sunday 22nd September 2024)"
	revision: "9"

class
	EL_SINGLETON_TABLE

inherit
	EL_HASH_TABLE [ANY, INTEGER]
		rename
			put as table_put,
			remove as table_remove,
			item as table_item,
			has as has_type_id
		export
			{NONE} all
		redefine
			make
		end

	EL_SINGLE_THREAD_ACCESS undefine copy, default_create, is_equal end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			make_default
		end

feature -- Element change

	put (obj: ANY)
		do
			restrict_access
				table_put (obj, {ISE_RUNTIME}.dynamic_type (obj))
			end_restriction
		end

	remove (obj: ANY)
		do
			restrict_access
				table_remove ({ISE_RUNTIME}.dynamic_type (obj))
			end_restriction
		end

feature -- Access

	item (a_type_id: INTEGER; conforming: BOOLEAN): ANY
		do
			restrict_access
				if has_type_key (a_type_id, conforming) then
					Result := found_item
				end
			end_restriction
		end

feature -- Status query

	has (obj: ANY): BOOLEAN
		do
			restrict_access
				Result := has_type_id ({ISE_RUNTIME}.dynamic_type (obj))
			end_restriction
		end

	has_type (type: TYPE [ANY]): BOOLEAN
		-- `True' if `has_type_id (type.type_id)' is true
		do
			restrict_access
				Result := has_type_id (type.type_id)
			end_restriction
		end

	has_conforming_type (type: TYPE [ANY]): BOOLEAN
		-- `True' is either an exact type or a type that conforms to `type' is present
		do
			restrict_access
				if has_type_id (type.type_id) then
					Result := True
				else
					Result := across key_list as type_id some
						{ISE_RUNTIME}.type_conforms_to (type_id.item, type.type_id)
					end
				end
			end_restriction
		end

feature {NONE} -- Implementation

	has_type_key (a_type_id: INTEGER; conforming: BOOLEAN): BOOLEAN
		-- `True' if table has `a_type_id' or else if `conforming' then `True' if a conforming type exists
		-- `found_item' is set to found item when `True'
		do
			Result := has_key (a_type_id)
			if not Result and conforming then
				across key_list as type_id until Result loop
					if {ISE_RUNTIME}.type_conforms_to (type_id.item, a_type_id) and then has_key (type_id.item) then
						Result := True
					end
				end
			end
		end

end