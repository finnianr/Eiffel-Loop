note
	description: "Thread safe table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 8:56:06 GMT (Friday   4th   October   2019)"
	revision: "1"

class
	EL_SINGLETON_TABLE

inherit
	HASH_TABLE [ANY, INTEGER]
		rename
			put as table_put,
			item as table_item
		export
			{NONE} all
		redefine
			make
		end

	EL_SINGLE_THREAD_ACCESS undefine copy, is_equal end

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

	has_type (a_type_id: INTEGER; conforming: BOOLEAN): BOOLEAN
		-- `True' if table has `a_type_id' or else if `conforming' then `True' if a conforming type exists
		do
			restrict_access
				Result := has (a_type_id)
				if not Result and conforming then
					Result := across current_keys as type_id some
						{ISE_RUNTIME}.type_conforms_to (type_id.item, a_type_id)
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
				across current_keys as type_id until Result loop
					if {ISE_RUNTIME}.type_conforms_to (type_id.item, a_type_id) and then has_key (type_id.item) then
						Result := True
					end
				end
			end
		end

end
