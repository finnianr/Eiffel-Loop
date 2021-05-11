note
	description: "Reflected reference field conforming to parameter `G'"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-11 12:51:45 GMT (Tuesday 11th May 2021)"
	revision: "24"

class
	EL_REFLECTED_REFERENCE [G]

inherit
	EL_REFLECTED_FIELD
		rename
			reference_value as value
		redefine
			initialize, make, value, is_initialized, set_from_memory, write_to_memory
		end

	EL_SHARED_NEW_INSTANCE_TABLE

	EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_CLASS_ID

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: like enclosing_object; a_index: INTEGER; a_name: STRING)
		do
			Precursor (a_object, a_index, a_name)
			if attached {EL_READER_WRITER_INTERFACE [G]} Reader_writer_table.item (type_id) as interface then
				reader_writer_interface := interface
			end
		end

feature -- Access

	generic_type: TYPE [ANY]
		do
			Result := {G}
		end

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
			Result := New_instance_table.has (type_id) or else conforms_to_type (Class_id.EL_MAKEABLE)
		end

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			enclosing_object := a_object
			Result := attached reference_field (index)
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
		end

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

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached reader_writer_interface as interface and then attached value (a_object) as v then
				interface.set (v, memory)
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

	write (a_object: EL_REFLECTIVE; writable: EL_WRITEABLE)
		do
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached reader_writer_interface as interface and then attached value (a_object) as v then
				interface.write (v, memory)
			else
				write (a_object, memory)
			end
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
			if not is_assigned then
				if Makeable_factory.valid_type_id (type_id) -- conforms to EL_MAKEABLE
					and then attached {G} Makeable_factory.new_item_from_type_id (type_id) as new
				then
					Result := new
				elseif attached {G} Eiffel.new_instance_of (type_id) as new then
					-- Uninitialized
					Result := new
				end
			end
		end

feature {NONE} -- Internal attributes

	reader_writer_interface: detachable EL_READER_WRITER_INTERFACE [G]

feature {NONE} -- Constants

	Makeable_factory: EL_MAKEABLE_OBJECT_FACTORY
		once
			create Result
		end

note
	descendants: "[
			EL_REFLECTED_REFERENCE [G]
				[$source EL_REFLECTED_STORABLE]
				[$source EL_REFLECTED_TUPLE]
					[$source EL_REFLECTED_STORABLE_TUPLE]
				[$source EL_REFLECTED_BOOLEAN_REF]
				[$source EL_REFLECTED_MAKEABLE_FROM_STRING]* [MAKEABLE -> [$source EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]]
					[$source EL_REFLECTED_MAKEABLE_FROM_ZSTRING]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING_8]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING_32]
				[$source EL_REFLECTED_DATE_TIME]
				[$source EL_REFLECTED_DATE]
				[$source EL_REFLECTED_PATH]
				[$source EL_REFLECTED_STRING]* [S -> [$source STRING_GENERAL]]
					[$source EL_REFLECTED_URI]
					[$source EL_REFLECTED_STRING_8]
					[$source EL_REFLECTED_STRING_32]
					[$source EL_REFLECTED_ZSTRING]
				[$source EL_REFLECTED_COLLECTION] [G]
				[$source EL_CACHEABLE_REFLECTED_REFERENCE]* [G -> [$source HASHABLE]]
					[$source EL_REFLECTED_STRING]* [S -> [$source STRING_GENERAL]]
				[$source EL_REFLECTED_TIME]
				[$source EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT]
				[$source EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT]
	]"

end