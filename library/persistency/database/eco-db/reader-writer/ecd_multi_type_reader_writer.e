note
	description: "Eco-DB file reader/writer for storing types conforming to types [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-24 12:28:22 GMT (Thursday 24th May 2018)"
	revision: "5"

class
	ECD_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	ECD_READER_WRITER [G]
		rename
			make as make_default
		redefine
			write, read_header, write_header, new_item
		end

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (a_descendants: like descendants)
		do
			descendants := a_descendants
			make_default
			create storable_object.make (Current)
			create type_index_table.make_equal (a_descendants.count + 1)
			type_index_table.put (0, ({G}).type_id)
			across a_descendants as descendant loop
				type_index_table.put (type_index_table.count.to_natural_8, descendant.item.type_id)
			end
		end

feature -- Basic operations

	write (a_writeable: EL_STORABLE; a_file: RAW_FILE)
		do
			if type_index_table.has_key (Eiffel.dynamic_type (a_writeable)) then
				type_index := type_index_table.found_item
			else
				type_index := 0
			end
			Precursor (a_writeable, a_file)
		end

feature {NONE} -- Implementation

	read_header (a_file: RAW_FILE)
		do
			Precursor (a_file)
			a_file.read_natural_8
			type_index := a_file.last_natural_8
		end

	write_header (a_file: RAW_FILE)
		do
			Precursor (a_file)
			a_file.put_natural_8 (type_index)
		end

	new_item: G
		do
			if type_index = 0 then
				create Result.make_default
			elseif attached {G} Eiffel.new_instance_of (descendants.item (type_index.to_integer_32).type_id) as l_result then
				Result := l_result
				Result.make_default
			else
				create Result.make_default
			end
		end

feature {NONE} -- Internal attributes

	descendants: ARRAY [TYPE [G]]

	type_index: NATURAL_8

	type_index_table: HASH_TABLE [NATURAL_8, INTEGER]

	storable_object: REFLECTED_REFERENCE_OBJECT
end
