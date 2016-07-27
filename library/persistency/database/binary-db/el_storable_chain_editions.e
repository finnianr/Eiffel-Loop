note
	description: "Summary description for {EL_BINARY_STORABLE_EDITIONS_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-02 10:18:24 GMT (Saturday 2nd January 2016)"
	revision: "5"

deferred class
	EL_STORABLE_CHAIN_EDITIONS [G -> EL_STORABLE create make_default end]

inherit
	CHAIN [G]
		undefine
			is_equal, copy, prune_all, prune, is_inserted, move, go_i_th, new_cursor,
			isfirst, islast, first, last, start, finish, readable, off, remove
		end

feature {NONE} -- Initialization

	make (storable_chain: like editions_file.item_chain)
			--
		do
			if is_encrypted then
				create {EL_ENCRYPTABLE_CHAIN_EDITIONS_FILE [G]} editions_file.make (editions_file_path, storable_chain)
			else
				create editions_file.make (editions_file_path, storable_chain)
			end
		end

feature -- Access

	editions_file: EL_CHAIN_EDITIONS_FILE [G]

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
			editions_file.reopen
		end

feature -- Status query

	has_version_mismatch: BOOLEAN
			-- True when the `software_version' does not match the stored data version
		deferred
		end

	is_integration_pending: BOOLEAN
			-- True when it becomes necessary to integrate editions into main list (chain) by calling `store'
		do
			Result := editions_file.kilo_byte_count > Minimum_editions_to_integrate
							or else has_version_mismatch or else editions_file.has_checksum_mismatch
																						-- A checksum mismatch indicates that the editions
																						-- have become corrupted somewhere, so save
																						-- what's good and start a clean editions.
		end

	is_encrypted: BOOLEAN
		deferred
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

	delete
		do
			if editions_file.is_open_write then
				editions_file.put_edition (editions_file.Edition_code_delete, item)
			end
			chain_delete
		end

feature -- Status change

	reopen
		do
			editions_file.reopen
		end

feature {NONE} -- Implementation

	editions_file_path: EL_FILE_PATH
		do
			Result := file_path.with_new_extension ("editions.dat")
		end

	chain_delete
			--
		deferred
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

	store
		deferred
		end

	file_path: EL_FILE_PATH
		deferred
		end

feature {NONE} -- Constants

	Minimum_editions_to_integrate: REAL
			-- Minimum file size in kb of editions to integrate with main XML body.
		once
			Result := 50 -- Kb
		end

end