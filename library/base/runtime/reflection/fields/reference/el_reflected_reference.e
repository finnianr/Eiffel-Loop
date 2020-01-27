note
	description: "Reflected reference field conforming to parameter `G'"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 18:47:08 GMT (Monday 27th January 2020)"
	revision: "13"

class
	EL_REFLECTED_REFERENCE [G]

inherit
	EL_REFLECTED_FIELD
		rename
			reference_value as value
		redefine
			initialize, value, is_initialized
		end

	EL_SHARED_NEW_INSTANCE_TABLE

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).out
		end

	value (a_object: EL_REFLECTIVE): G
		do
			enclosing_object := a_object
			if attached {G} reference_field (index) as l_value then
				Result := l_value
			else
				Result := new_instance
			end
		end

feature -- Status query

	Is_expanded: BOOLEAN = False

	is_initializeable: BOOLEAN
		-- `True' when it is possible to create an initialized instance of the field

		-- (To satisfy this precondition, override `{EL_REFLECTIVE}.new_instance_functions'
		-- to return a suitable creation function)
		do
			Result := New_instance_table.has (type_id)
							or else field_conforms_to (type_id, Makeable_from_string_general_type)
							or else field_conforms_to (type_id, Makeable_type)

		end

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			enclosing_object := a_object
			Result := attached reference_field (index)
		end

feature -- Basic operations

	initialize (a_object: EL_REFLECTIVE)
		require else
			initializeable: is_initializeable
		do
			set (a_object, new_instance)
		end

	reset (a_object: EL_REFLECTIVE)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {BAG [ANY]} l_value as bag then
				bag.wipe_out
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: ANY)
		do
			enclosing_object := a_object
			set_reference_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
			-- Internal attributes
		do
			set_from_string (a_object, a_value.out)
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITEABLE)
		do
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current).is_equal (value (other))
		end

feature {NONE} -- Implementation

	new_instance: G
		-- new initialized instance of field
		local
			new_func: FUNCTION [ANY]; is_assigned: BOOLEAN
		do
			if New_instance_table.has_key (type_id) then
				new_func := New_instance_table.found_item
				new_func.apply
				if attached {G} new_func.last_result as new then
					Result := new
					is_assigned := True
				end
			end
			if not is_assigned
				and then Makeable_factory.valid_type_id (type_id) -- conforms to EL_MAKEABLE
				and then attached {G} Makeable_factory.new_item_from_type_id (type_id) as new
			then
				Result := new
			elseif attached {G} Eiffel.new_instance_of (type_id) as new then
				-- Uninitialized
				Result := new
			end
		end

feature {NONE} -- Constants

	Makeable_factory: EL_MAKEABLE_OBJECT_FACTORY
		once
			create Result
		end

note
	descendants: "[
			EL_REFLECTED_REFERENCE
				[$source EL_REFLECTED_READABLE]*
					[$source EL_REFLECTED_STORABLE]
					[$source EL_REFLECTED_DATE_TIME]
					[$source EL_REFLECTED_TUPLE]
				[$source EL_REFLECTED_BOOLEAN_REF]
				[$source EL_REFLECTED_PATH]
				[$source EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT]
				[$source EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT]
				[$source EL_REFLECTED_STRING_GENERAL]*
					[$source EL_REFLECTED_ZSTRING]
					[$source EL_REFLECTED_STRING_8]
					[$source EL_REFLECTED_STRING_32]
				[$source EL_REFLECTED_COLLECTION]
				[$source EL_REFLECTED_MAKEABLE_FROM_STRING]*
					[$source EL_REFLECTED_MAKEABLE_FROM_ZSTRING]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING_8]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING_32]
	]"
end

