note
	description: "Reflected reference field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-18 11:48:07 GMT (Wednesday 18th April 2018)"
	revision: "6"

class
	EL_REFLECTED_REFERENCE

inherit
	EL_REFLECTED_FIELD
		redefine
			make, initialize, value, is_initialized
		end

	EL_SHARED_DEFAULT_VALUE_TABLE

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER_32; a_name: STRING_8)
		do
			Precursor (a_object, a_index, a_name)
			if default_defined then
				initialize_default
			elseif Default_value_table.has_key (type_id) then
				default_value := Default_value_table.found_item
			else
				default_value := new_default_value
			end
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).out
		end

	value (a_object: EL_REFLECTIVE): like default_value
		do
			enclosing_object := a_object
			if attached {like default_value} reference_field (index) as l_value then
				Result := l_value
			elseif attached default_value then
				Result := default_value.twin
			else
				Result := new_default_value
			end
		end

feature -- Status query

	Is_expanded: BOOLEAN = False

	default_defined: BOOLEAN
		do
			Result := not Default_value_table.has (type_id) and then field_conforms_to (type_id, Makeable_type)
		end

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			enclosing_object := a_object
			Result := attached reference_field (index)
		end

feature -- Basic operations

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

	initialize (a_object: EL_REFLECTIVE)
		do
			if attached default_value then
				set (a_object, default_value.twin)
			end
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
			-- Internal attributes
		do
			set (a_object, a_value.to_reference)
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

	new_default_value: like default_value
		-- uninitialized value
		do
			if attached {like default_value} Eiffel.new_instance_of (type_id) as new_instance then
				Result := new_instance
			end
		end

	initialize_default
		do
			if attached {EL_MAKEABLE} new_default_value as new_value then
				new_value.make
				default_value := new_value
			end
		ensure
			default_value_initialized: attached default_value
		end

feature {NONE} -- Internal attributes

	default_value: detachable ANY

end

