note
	description: "Reflected reference field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-22 16:49:38 GMT (Monday 22nd January 2018)"
	revision: "5"

class
	EL_REFLECTED_REFERENCE

inherit
	EL_REFLECTED_FIELD
		redefine
			make, set_default_value, value
		end

	EL_SHARED_REFLECTION_MANAGER
		rename
			initialize_reflection as initialize_nothing
		end

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER_32; a_name: STRING_8)
		do
			Precursor (a_object, a_index, a_name)
			if default_defined then
				set_default
			else
				default_value := Reflection_manager.default_value_by_type (type_id)
			end
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).out
		end

feature -- Status query

	Is_expanded: BOOLEAN = False

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: ANY)
		do
			enclosing_object := a_object
			set_reference_field (index, a_value)
		end

	set_default_value (a_object: EL_REFLECTIVE)
		do
			if attached default_value then
				if twin_default_value then
					set (a_object, default_value.twin)
				else
					set (a_object, default_value)
				end
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

	default_defined: BOOLEAN
		do
		end

	new_default_value: like default_value
		-- uninitialized value
		do
			if attached {like default_value} Eiffel.new_instance_of (type_id) as new_instance then
				Result := new_instance
			end
		end

	set_default
		do
		end

	twin_default_value: BOOLEAN
		 do
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

feature {NONE} -- Internal attributes

	default_value: detachable ANY

end

