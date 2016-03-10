note
	description: "[
		Object to record to disk any editions made to current list of XML storable objects. If the list is reloaded 
		the editions can be reapplied restoring the state of the previous application session. 
		
		The benefits are twofold:
			1. A large list need not be saved each time the application exits as the most recent editions are recorded to disk.
			
			2. If the application crashes unexpectedly, no data is lost.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-28 17:08:28 GMT (Friday 28th June 2013)"
	revision: "2"

deferred class
	EL_STORABLE_XML_EDITIONS_LIST [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT create make end]

inherit
	LIST [STORABLE_TYPE]
		undefine
			is_equal, copy, prune_all, prune, is_inserted, move, go_i_th, new_cursor,
			isfirst, islast, first, last, start, finish, readable, off, before, after, remove
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		do
			editions := create_editions (a_file_path)
			editions.apply
			is_open := True
		end

feature -- Access

	editions: like create_editions
		-- Element list editions journal

feature -- Element change

	set_editions_file_path (a_output_path: EL_FILE_PATH)
			--
		do
			if is_open then
				editions.set_storage_file_path (a_output_path)
			end
		end

	replace (v: like item)
			--
		do
			list_replace (v)
			if is_open then
				editions.put_replacement (v, index)
			end
		end

	extend (v: like item)
			--
		do
			list_extend (v)
			if is_open then
				editions.put_extension (v)
			end
		end

feature -- Status query

	is_open: BOOLEAN
		-- True if any existing editions have already been applied at initialization

	is_time_to_store: BOOLEAN
		do
			Result := editions.file_size_kb > Minimum_editions_to_integrate
		end

feature -- Removal

	remove
			--
		do
			if is_open then
				editions.put_removal (index)
			end
			list_remove
		end

feature -- Status change

	reopen
		do
			editions.reopen
			is_open := True
		end

	close_and_delete
			--
		do
			editions.close_and_delete
			is_open := False
		end

	close
			--
		do
			editions.close
			is_open := False
		end

feature {NONE} -- Implementation

	list_remove
			--
		deferred
		end

	list_extend (v: like item)
			--
		deferred
		end

	list_replace (v: like item)
			--
		deferred
		end

	create_editions (a_file_path: EL_FILE_PATH): EL_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE]
		do
			create Result.make (Current, a_file_path)
		end

	prepare_new_item (new_item: like item)
			--
		do
		end

feature -- Constants

	Minimum_editions_to_integrate: REAL
			-- Minimum file size in kb of editions to integrate with main XML body.
		once
			Result := 50 -- Kb
		end

end
