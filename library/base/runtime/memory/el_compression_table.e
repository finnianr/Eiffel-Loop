note
	description: "Table of compressed objects conforming to [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 16:28:08 GMT (Saturday 31st December 2022)"
	revision: "4"

class
	EL_COMPRESSION_TABLE [G -> EL_STORABLE create make_default end, K -> HASHABLE]

inherit
	HASH_TABLE [MANAGED_POINTER, K]
		rename
			at as at_key,
			found_item as found_buffer,
			item as item_buffer,
			force as force_buffer,
			put as put_buffer
		export
			{NONE} all
			{ANY} has, current_keys
		redefine
			has_key, make
		end

	EL_STORABLE_HANDLER

	EL_MODULE_EIFFEL

create
	make

feature -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create Default_item.make_default
			found_item := Default_item
		end

feature -- Access

	found_item: G

	item alias "[]", at alias "@" (key: K): detachable G assign force
		do
			if attached at_key (key) as l_buffer and then attached Reader_writer as reader then
				Result := new_item (reader, l_buffer)
			end
		end

feature -- Measurement

	size_compressed_item: INTEGER
		-- Physical size of compressed item
		do
			Result := Eiffel.physical_size (found_buffer) + found_buffer.count
		end

feature -- Status query

	has_key (key: K): BOOLEAN
		do
			if Precursor (key) and then attached Reader_writer as reader then
				set_found_item (reader)
				Result := True
			else
				found_item := Default_item
			end
		end

feature -- Element change

	force (new: G; key: K)
		do
			if attached Reader_writer as writer then
				write_to_buffer (new, writer)
				force_buffer (Buffer.twin, key)
				if found and then attached Reader_writer as reader then
					set_found_item (reader)
				else
					found_item := default_item
				end
			end
		end

	put (new: G; key: K)
		do
			if attached Reader_writer as writer then
				write_to_buffer (new, writer)
				put_buffer (Buffer.twin, key)
				if inserted then
					found_item := new

				elseif attached Reader_writer as reader then
					set_found_item (reader)

				end
			end
		end

feature {NONE} -- Implementation

	write_to_buffer (new: G; writer: EL_MEMORY_READER_WRITER)
		do
			writer.set_for_writing
			writer.make_with_buffer (Buffer)
			writer.reset_count
			new.write (writer)
		end

	new_item (reader: EL_MEMORY_READER_WRITER; a_buffer: MANAGED_POINTER): G
		do
			reader.set_for_reading
			reader.reset_count
			reader.make_with_buffer (a_buffer)
			create Result.make_default
			Result.read (reader)
		end

	set_found_item (reader: EL_MEMORY_READER_WRITER)
		do
			found_item := new_item (reader, found_buffer)
		end

feature {NONE} -- Internal attributes

	Default_item: G

feature {NONE} -- Constants

	Buffer: MANAGED_POINTER
		once
			create Result.make (0)
		end

	Reader_writer: EL_MEMORY_READER_WRITER
		once
			create Result.make_with_buffer (Buffer)
		end

end