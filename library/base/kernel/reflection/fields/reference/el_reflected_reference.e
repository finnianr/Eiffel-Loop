note
	description: "Reflected reference field conforming to parameter `G'"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 9:15:34 GMT (Monday 26th August 2024)"
	revision: "47"

class
	EL_REFLECTED_REFERENCE [G]

inherit
	EL_REFLECTED_FIELD
		rename
			abstract_type as Reference_type,
			reference_value as value
		redefine
			initialize, make, value, is_initialized, set_from_memory, write_to_memory
		end

	EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_FACTORIES

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: IMMUTABLE_STRING_8)
		do
			Precursor (a_object, a_index, a_name)
			if attached {EL_READER_WRITER_INTERFACE [G]} Reader_writer_table.item (type_id) as extra then
				reader_writer_extra := extra
			end
			factory := new_factory
		end

feature -- Access

	address (a_object: EL_REFLECTIVE): POINTER
		do
			if attached value (a_object) as field_object
				and then attached Once_reference as field_reference
			then
				field_reference.set_object (field_object)
				Result := field_reference.object_address
			end
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := Eiffel.deep_physical_size (value (a_object))
		end

	value (a_object: EL_REFLECTIVE): G
		local
			object_ptr: POINTER
		do
			object_ptr := {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0)
			if attached {G} {ISE_RUNTIME}.reference_field (index, object_ptr, 0) as l_value then
				Result := l_value
			else
				Result := new_instance
			end
		end

	value_type, group_type: TYPE [ANY]
		do
			Result := {G}
		end

feature -- Conversion

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).out
		end

feature -- Status query

	Is_expanded: BOOLEAN = False

	is_initializeable: BOOLEAN
		-- `True' when it is possible to create an initialized instance of the field

		-- (To satisfy this precondition, override `{EL_REFLECTIVE}.new_instance_functions'
		-- to return a suitable creation function)
		do
			Result := attached factory
		end

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := attached {ISE_RUNTIME}.reference_field (index, $a_object, 0)
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			write (a_object, str)
		end

	initialize (a_object: EL_REFLECTIVE)
		require else
			initializeable: is_initializeable
		do
			set (a_object, new_instance)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached {COLLECTION [ANY]} value (a_object) as collection then
				collection.wipe_out
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: G)
		do
			{ISE_RUNTIME}.set_reference_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0, a_value
			)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
			-- Internal attributes
		do
			set_from_string (a_object, a_value.out)
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached reader_writer_extra as extra and then attached value (a_object) as v then
				extra.set (v, memory)
			else
				set_from_readable (a_object, memory)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		end

	set_from_utf_8 (a_object: EL_REFLECTIVE; utf_8: READABLE_STRING_8)
		do
			set_from_string (a_object, create {ZSTRING}.make_from_utf_8 (utf_8))
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		do
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached reader_writer_extra as interface and then attached value (a_object) as v then
				interface.write (v, memory)
			else
				write (a_object, memory)
			end
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			if attached value (a_current) as this_value and then attached value (other) as other_value then
				Result := this_value.is_equal (other_value)
			else
				Result := True -- Both fields are Void so they are equal
			end
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [G]
		local
			agent_factory: EL_AGENT_FACILITATED_FACTORY [G]
		do
			if ({G}).conforms_to ({EL_MAKEABLE})
				and then attached {EL_FACTORY [G]} Makeable_factory.new_item_factory (type_id) as f then
				Result := f
			else
				create agent_factory.make (type_id)
				if agent_factory.is_useable then
					Result := agent_factory

				elseif attached {EL_FACTORY [G]} Default_factory.new_item_factory (type_id) as f then
					Result := f
				end
			end
		end

	new_instance: G
		-- new initialized instance of field
		do
			if attached factory as f and then attached f.new_item as new then
				Result := new

			elseif attached {G} Eiffel.new_instance_of (type_id) as new then
				-- Uninitialized instance
				Result := new
			end
		end

feature {NONE} -- Internal attributes

	factory: like new_factory

	reader_writer_extra: detachable EL_READER_WRITER_INTERFACE [G];
		-- reader writer for supplementary types like `INTEGER_X' for example

feature {NONE} -- Constants

	Once_reference: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (create {ANY})
		end

note
	descendants: "[
			EL_REFLECTED_REFERENCE [G]
				${EL_REFLECTED_COLLECTION [G]}
				${EL_REFLECTED_TEMPORAL* [G -> ABSOLUTE]}
					${EL_REFLECTED_TIME}
					${EL_REFLECTED_DATE_TIME}
					${EL_REFLECTED_DATE}
				${EL_REFLECTED_TUPLE}
				${EL_REFLECTED_BOOLEAN_REF}
				${EL_REFLECTED_MANAGED_POINTER}
				${EL_REFLECTED_STORABLE}
				${EL_REFLECTED_REFERENCE_ANY}
				${EL_REFLECTED_MAKEABLE_FROM_STRING* [MAKEABLE -> EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]}
					${EL_REFLECTED_MAKEABLE_FROM_STRING_8}
					${EL_REFLECTED_MAKEABLE_FROM_STRING_32}
					${EL_REFLECTED_MAKEABLE_FROM_ZSTRING}
				${EL_REFLECTED_HASHABLE_REFERENCE [H -> HASHABLE]}
					${EL_REFLECTED_STRING* [S -> READABLE_STRING_GENERAL create make end]}
						${EL_REFLECTED_STRING_8}
						${EL_REFLECTED_IMMUTABLE_STRING_8}
						${EL_REFLECTED_IMMUTABLE_STRING_32}
						${EL_REFLECTED_STRING_32}
						${EL_REFLECTED_URI [U -> EL_URI create make end]}
						${EL_REFLECTED_ZSTRING}
					${EL_REFLECTED_PATH}
	]"

end