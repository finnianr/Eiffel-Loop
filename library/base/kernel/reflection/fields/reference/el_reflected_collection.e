note
	description: "Reflected field conforming to [$source COLLECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 13:27:11 GMT (Friday 9th December 2022)"
	revision: "17"

class
	EL_REFLECTED_COLLECTION [G]

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [G]]
		rename
			value as collection
		redefine
			make, new_factory, set_from_memory, set_from_string, to_string, write_to_memory
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_REUSEABLE

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER_32; a_name: STRING_8)
		require else
			is_string_convertible: Convert_string.has (({G}).type_id)
		do
			Precursor (a_object, a_index, a_name)
			item_type_id := ({G}).type_id
			if Item_reader_writer_table.has_key (item_type_id)
				and then attached {EL_READER_WRITER_INTERFACE [G]} Item_reader_writer_table.found_item as found_item
			then
				reader_writer := found_item
			end
		ensure then
			valid_reader_writer: attached reader_writer as rw implies rw.item_type ~ {G}
		end

feature -- Conversion

	to_string (a_object: EL_REFLECTIVE): ZSTRING
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_general (to_string_list (a_object))
			Result := list.comma_separated
		end

feature -- Status query

	has_character_data: BOOLEAN
		do
			Result := Collection_type_table.is_character_data (item_type_id)
		end

feature -- Basic operations

	extend_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached reader_writer as reader then
				collection (a_object).extend (reader.read_item (readable))

			elseif attached {G} Convert_string.to_type_of_type (readable.read_string, item_type_id) as new then
				collection (a_object).extend (new)
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		local
			item_count, i: INTEGER
		do
			if attached reader_writer as reader
				and then attached {CHAIN [G]} collection (a_object) as item_list
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

	set_from_string (a_object: EL_REFLECTIVE; csv_string: READABLE_STRING_GENERAL)
		-- if collection conforms to type `CHAIN [G]' when {G} is character data type
		-- then fill with data from comma separated `csv_string' using left adjusted values
		do
			if attached {CHAIN [ANY]} collection (a_object) as chain then
				if Convert_string.is_convertible_list (item_type_id, csv_string, True) then
					chain.wipe_out
					Convert_string.append_to_chain (item_type_id, chain, csv_string, True)
				else
					check
						convertable_string: False
					end
				end
			end
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached reader_writer as writer
				and then attached {FINITE [G]} collection (a_object) as finite
				and then attached finite.linear_representation as item_list
			then
				memory.write_integer_32 (finite.count)
				item_list.do_all (agent writer.write (?, memory))
			end
		end

feature -- Conversion

	to_string_list (a_object: EL_REFLECTIVE): EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		local
			intermediate: EL_ARRAYED_RESULT_LIST [G, READABLE_STRING_GENERAL]
		do
			create intermediate.make (collection (a_object), agent to_item_string)
			Result := intermediate.to_list
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [COLLECTION [G]]
		do
			if attached {EL_FACTORY [COLLECTION [G]]} Arrayed_list_factory.new_item_factory (type_id) as f then
				Result := f
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

		EL_ZSTRING_READER_WRITER, EL_STRING_8_READER_WRITER, EL_STRING_32_READER_WRITER
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

			elseif attached reader_writer as writer then
				across Reuseable.string as reuse loop
					writer.write (item, reuse.item)
					Result := reuse.item.twin
				end
			else
				Result := item.out
			end
		end

feature {NONE} -- Internal attributes

	item_type_id: INTEGER

	reader_writer: detachable EL_READER_WRITER_INTERFACE [G]
		-- item reader/writer

feature {NONE} -- Constants

	Item_reader_writer_table: HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], INTEGER]
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