note
	description: "[
		Reflected field conforming to ${COLLECTION [G]} with ability to create factories for types
		conforming to ${ARRAYED_LIST [G]} or ${HASH_TABLE [G, HASHABLE]}
	]"
	notes: "[
		Factory types returned by `new_factory'
		
			EL_FACTORY [G]*
				${EL_ARRAYED_LIST_FACTORY [G -> ARRAYED_LIST [ANY] create make end]}
				${EL_HASH_TABLE_FACTORY [G -> HASH_TABLE [ANY, HASHABLE] create make, make_equal end]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:24:05 GMT (Monday 28th April 2025)"
	revision: "42"

class
	EL_REFLECTED_COLLECTION [G]

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [G]]
		rename
			value as collection
		redefine
			append_to_string, group_type, post_make, is_abstract, is_storable_type, new_factory,
			set_from_memory, set_from_string, to_string, write
		end

	EL_MODULE_CONVERT_STRING

	EL_STRING_8_CONSTANTS

	EL_SHARED_CLASS_ID; EL_SHARED_NEW_INSTANCE_TABLE; EL_SHARED_ZSTRING_BUFFER_POOL

create
	make, default_create -- to satisfy constraint of `EL_REFLECTED_COLLECTION_FACTORY'

feature {NONE} -- Initialization

	post_make
		-- initialization after types have been set
		require else
			is_string_convertible: Convert_string.has (({G}).type_id)
		do
			item_type_id := ({G}).type_id
			Precursor

		-- Check if there is a function to make new collection items that has a target which is
		-- is the same type as the current object type
			if New_instance_table.has_key (item_type_id)
				and then attached {FUNCTION [G]} New_instance_table.found_item as l_new_item_function
				and then {ISE_RUNTIME}.dynamic_type (l_new_item_function.target) = object_type
			then
				new_item_function := l_new_item_function
			end

			if Item_reader_writer_table.has_key (item_type_id)
				and then attached {EL_READER_WRITER_INTERFACE [G]} Item_reader_writer_table.found_item as found_item
			then
				reader_writer := found_item

			elseif attached makeable_reader_writer_factory as reader_writer_factory
				and then attached {EL_READER_WRITER_INTERFACE [G]} reader_writer_factory.new_item as new
			then
				reader_writer := new
				Item_reader_writer_table.extend (new, item_type_id)
			end
		ensure then
			valid_reader_writer: attached reader_writer as rw implies rw.item_type ~ {G}
		end

feature -- Access

	item_type_id: INTEGER

	group_type: TYPE [ANY]
		do
			Result := {COLLECTION [ANY]}
		end

feature -- Conversion

	to_string (object: ANY): ZSTRING
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_general (to_string_list (object))
			Result := list.comma_separated
		end

feature -- Status query

	has_character_data: BOOLEAN
		do
			Result := Eiffel.is_type_in_set (item_type_id, Class_id.Character_data_types)
		end

	is_extendible (object: ANY): BOOLEAN
		do
			Result := attached collection (object) and then attached reader_writer
		end

	is_reflective_item: BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (item_type_id, Class_id.EL_REFLECTIVE)
		end

feature -- Basic operations

	append_to_string (object: ANY; str: ZSTRING)
		local
			i: INTEGER
		do
			if attached {ITERABLE [G]} collection (object) as reflective_list then
				across reflective_list as list loop
					i := i + 1
					if i > 1 then
						str.append_string_general (Comma_space)
					end
					if attached reader_writer as writer then
						writer.write (list.item, str)
					end
				end
			end
		end

	extend_with_new (object: ANY)
		local
			new_item: G
		do
			if attached collection (object) as container then
				if attached new_item_function as function then
					function.set_target (object)
					function.apply
					new_item  := function.last_result

				elseif attached reader_writer as rw  then
					new_item := rw.new_item
				end
				container.extend (new_item)
			end
		end

	extend_from_readable (object: ANY; readable: EL_READABLE)
		do
			if attached reader_writer as reader then
				collection (object).extend (reader.read_item (readable))

			elseif attached {G} Convert_string.to_type_of_type (readable.read_string, item_type_id) as new then
				collection (object).extend (new)
			end
		end

	print_items (object: ANY; a_lio: EL_LOGGABLE)
		require
			reflective_item: is_reflective_item
		local
			i: INTEGER
		do
			if attached {ITERABLE [EL_REFLECTIVE]} collection (object) as reflective_list then
				across reflective_list as list loop
					i := i + 1
					a_lio.put_labeled_substitution (name, "[%S]", [i])
					a_lio.tab_right
					a_lio.put_new_line
					list.item.print_fields (a_lio)
					a_lio.tab_left
					a_lio.put_new_line
				end
			end
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		local
			item_count, i: INTEGER
		do
			if attached reader_writer as reader
				and then attached {CHAIN [G]} collection (object) as item_list
			then
				item_count := memory.read_integer_32
				if attached {ARRAYED_LIST [G]} item_list as array then
					array.grow (item_count)
				end
				from i := 1 until i > item_count loop
					item_list.extend (reader.read_item (memory))
					i := i + 1
				end
			end
		end

	set_from_string (object: ANY; csv_string: READABLE_STRING_GENERAL)
		-- if collection conforms to type `CHAIN [G]' when {G} is character data type
		-- then fill with data from comma separated `csv_string' using left adjusted values
		do
			if attached {CHAIN [ANY]} collection (object) as chain then
				if Convert_string.is_convertible_list (item_type_id, csv_string, ',', True) then
					chain.wipe_out
					Convert_string.append_to_chain (item_type_id, chain, csv_string, True)
				else
					check
						convertable_string: False
					end
				end
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		do
			if attached reader_writer as writer
				and then attached {FINITE [G]} collection (object) as finite
				and then attached finite.linear_representation as item_list
			then
				writable.write_integer_32 (finite.count)
				item_list.do_all (agent writer.write (?, writable))
			end
		end

feature -- Conversion

	to_string_list (object: ANY): EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		local
			intermediate: EL_ARRAYED_RESULT_LIST [G, READABLE_STRING_GENERAL]
		do
			if attached collection (object) as container then
				create intermediate.make (container, agent to_item_string)
				create Result.make_from_special (intermediate.area)
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	makeable_reader_writer_factory: detachable like Makeable_reader_writer_factory_factory.new_item_factory
		do
			if {ISE_RUNTIME}.type_conforms_to (item_type_id, Class_id.EL_MAKEABLE) then
				Result := Makeable_reader_writer_factory_factory.new_item_factory (item_type_id)
			end
		end

	new_factory: detachable EL_FACTORY [COLLECTION [G]]
		-- create factory for types conforming to `ARRAYED_LIST [ANY]' or `HASH_TABLE [ANY, HASHABLE]'
		local
			factory_any: detachable EL_FACTORY [ANY]
		do
			if Eiffel.field_conforms_to (type_id, Class_id.ARRAYED_LIST__ANY) then
				factory_any := Arrayed_list_factory.new_item_factory (type_id)

			elseif Eiffel.field_conforms_to (type_id, Class_id.HASH_TABLE__ANY__HASHABLE) then
				factory_any := Hash_table_factory.new_item_factory (type_id)
			end
			if attached {EL_FACTORY [COLLECTION [G]]} factory_any as factory_collection then
				Result := factory_collection
			else
				Result := Precursor
			end
		end

	reader_writer_types: TUPLE [
		EL_BOOLEAN_READER_WRITER,

		EL_CHARACTER_8_READER_WRITER, EL_CHARACTER_32_READER_WRITER,

		EL_INTEGER_8_READER_WRITER, EL_INTEGER_16_READER_WRITER,
		EL_INTEGER_32_READER_WRITER, EL_INTEGER_64_READER_WRITER,

		EL_NATURAL_8_READER_WRITER, EL_NATURAL_16_READER_WRITER,
		EL_NATURAL_32_READER_WRITER, EL_NATURAL_64_READER_WRITER,

		EL_REAL_32_READER_WRITER, EL_REAL_64_READER_WRITER,

		EL_STRING_8_READER_WRITER, EL_STRING_32_READER_WRITER,
		EL_ZSTRING_READER_WRITER
	]
		do
			create Result
		end

	to_item_string (item: G): READABLE_STRING_GENERAL
		do
			if attached {READABLE_STRING_GENERAL} item as str then
				Result := str

			elseif attached {EL_PATH} item as path then
				Result := path.to_string

			elseif attached reader_writer as writer and then attached String_pool.borrowed_item as borrowed then
				if attached borrowed.empty as str then
					writer.write (item, str)
					Result := str.twin
				end
				borrowed.return
			else
				Result := item.out
			end
		end

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	reader_writer: detachable EL_READER_WRITER_INTERFACE [G]
		-- item reader/writer

	new_item_function: detachable FUNCTION [G]
		-- functon that returns a new item from agent defined in `enclosing_object' type
		-- (Example in class `FTP_BACKUP_COMMAND')

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

	Is_storable_type: BOOLEAN = False
		-- is type storable using `EL_STORABLE' interface

	Item_reader_writer_table: EL_HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], INTEGER]
		local
			type_list: EL_TUPLE_TYPE_LIST [EL_READER_WRITER_INTERFACE [ANY]]
		once
			create type_list.make_from_tuple (reader_writer_types)
			create Result.make (type_list.count)
			across type_list as list loop
				if attached {EL_READER_WRITER_INTERFACE [ANY]} Eiffel.new_object (list.item) as new then
					Result.extend (new, new.item_type.type_id)
				end
			end
			-- Might also handle `COLLECTION [INTEGER_X]' from encryption.ecf for example
			Result.merge (Reader_writer_table)
		end

end