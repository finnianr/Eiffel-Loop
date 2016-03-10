note
	description: "Summary description for {EL_BINARY_STORABLE_EDITIONS_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 13:04:46 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	EL_STORABLE_CHAIN_EDITIONS [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	CHAIN [G]
		undefine
			is_equal, copy, prune_all, prune, is_inserted, move, go_i_th, new_cursor,
			isfirst, islast, first, last, start, finish, readable, off, remove
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make (storable_chain: like editions_file.item_chain)
			--
		do
			create editions_file.make (editions_file_path, storable_chain)
		end

feature -- Access

	editions_file: like Type_editions_file

feature -- Element change

	replace (a_item: like item)
			--
		do
			chain_replace (a_item)
			if editions_file.is_open_write then
				editions_file.put_edition (editions_file.Edition_code_replace, a_item)
			end
		end

	extend (a_item: like item)
			--
		do
			chain_extend (a_item)
			if editions_file.is_open_write then
				editions_file.put_edition (editions_file.Edition_code_extend, a_item)
			end
		end

feature -- Basic operations

	apply_editions
		do
			if editions_file.exists and then not editions_file.is_empty then
				editions_file.apply
			end
			editions_file.open_read_write
			editions_file.finish
		end

feature -- Status query

	is_time_to_store: BOOLEAN
		do
			Result := editions_file.kilo_byte_count > Minimum_editions_to_integrate
						or else editions_file.has_checksum_mismatch 	-- A checksum mismatch indicates that the editions
																		-- have become corrupted somewhere, so save
																		-- what's good and start a clean editions.
		end

feature -- Removal

	remove
			--
		do
			if editions_file.is_open_write then
				editions_file.put_edition (editions_file.Edition_code_remove, item)
			end
			chain_remove
		end

feature -- Status change

	reopen
		do
			editions_file.open_append
		end

feature {NONE} -- Implementation

	editions_file_path: EL_FILE_PATH
		do
			Result := file_path.with_new_extension ("editions.dat")
		end

	chain_remove
			--
		deferred
		end

	chain_extend (a_item: like item)
			--
		deferred
		end

	chain_replace (a_item: like item)
			--
		deferred
		end

	file_path: EL_FILE_PATH
		deferred
		end

feature {NONE} -- Type definitions

	Type_editions_file: EL_CHAIN_EDITIONS_FILE [G]
		do
		end

feature {NONE} -- Constants

	Minimum_editions_to_integrate: REAL
			-- Minimum file size in kb of editions to integrate with main XML body.
		once
			Result := 50 -- Kb
		end

end
