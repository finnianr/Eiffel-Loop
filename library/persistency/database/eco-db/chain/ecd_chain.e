note
	description: "[
		Chain of storable items which can be saved to and read from a file. The chain has the following
		features:
		
		* Support for AES encryption
		* Ability to mark items for deletion without actually having to remove them immediately. This allows
		implementations like class [$source ECD_REFLECTIVE_RECOVERABLE_CHAIN] to support field indexing.
		* Ability to store software version information which is available to the item
		implementing [$source EL_STORABLE].
	]"
	notes: "[
		Items must implement either the
		class [$source EL_STORABLE] or [$source EL_REFLECTIVELY_SETTABLE_STORABLE].

		The descendant class [$source ECD_RECOVERABLE_CHAIN] can be used to implement a proper
		indexed transactional database when used in conjunction with class [$source ECD_REFLECTIVE_RECOVERABLE_CHAIN].
		
		The routine `safe_store' stores the complete chain in a temporary file and then does a quick check
		on the integrity of the save by checking all the item headers. Only then is the stored file substituted
		for the previously stored file.
	]"
	to_do: "[
		Change `delete' routine to replace item with a shared default deleted item. This will allow deleted item to
		be garbage collected
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 9:18:25 GMT (Sunday 5th November 2023)"
	revision: "34"

deferred class
	ECD_CHAIN  [G -> EL_STORABLE create make_default end]

inherit
	CHAIN [G]
		rename
			append as append_sequence
		export
			{ANY} remove
		undefine
			-- Status query
			is_equal, isfirst, islast, valid_index, is_inserted, readable, there_exists, has,
			-- Element change
			append_sequence, copy, prune_all, prune, move, put_i_th, swap, force,
			-- Cursor movement
			start, finish, go_i_th, search,
			-- Access
			at, first, last, off, i_th, remove, index_of, new_cursor,
			-- Basic operations
			do_all, do_if, for_all
		end

	EL_FILE_PERSISTENT
		redefine
			make_from_file
		end

	EL_ENCRYPTABLE
		undefine
			copy, is_equal
		redefine
			set_encrypter, make_default
		end

	EL_STORABLE_HANDLER

	EL_FILE_OPEN_ROUTINES
		rename
			Append as Append_to
		end

	EL_SHARED_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make_default
		do
			if not attached encrypter then
				encrypter := Default_encrypter
			end
			reader_writer := new_reader_writer
			create header.make
			make_chain_implementation (0)
		end

	make_chain_implementation (a_count: INTEGER)
		deferred
		end

	make_from_file (a_file_path: FILE_PATH)
		local
			l_file: like new_file
		do
			make_default
			Precursor (a_file_path)

			if file_path.exists then
				l_file := new_file (file_path)
				l_file.open_read
				header.set_from_file (l_file)

				if header.version /= software_version then
					on_version_mismatch (header.version)
				end
				make_chain_implementation (header.stored_count)
			else
				make_chain_implementation (0)
				create l_file.make_open_write (file_path)
				put_header (l_file)
				header.set_version (software_version)
			end
			l_file.close

			retrieve
		end

	make_from_file_and_encrypter (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

feature -- Measurement

	deleted_count: INTEGER

	undeleted_count: INTEGER
		do
			Result := count - deleted_count
		end

	store_tick_count: INTEGER
		do
			Result := undeleted_count
		end

feature -- Access

	software_version: NATURAL
		-- Format of application version.
		deferred
		end

feature -- Basic operations

	for_all_undeleted (do_with_item: PROCEDURE [G])
		do
			from start until after loop
				if not item.is_deleted then
					do_with_item (item)
				end
				forth
			end
		end

	store_as (a_file_path: like file_path)
		local
			l_file: like new_file
			l_writer: like reader_writer
		do
--			log.enter_with_args ("store_as", << a_file_path >>)
			encrypter.reset
			l_file := new_file (a_file_path)
			l_file.open_write
			l_writer := reader_writer
			l_writer.set_for_writing

			put_header (l_file)

			from start until after loop
--				log.put_integer_field ("Writing item", index); log.put_new_line
				if not item.is_deleted then
					l_writer.write (item, l_file)
					progress_listener.notify_tick
				end
				forth
			end
			l_file.close
--			log.exit
		end

feature -- Element change

	set_encrypter (a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			if attached {EL_ENCRYPTABLE} reader_writer as rw then
				rw.set_encrypter (a_encrypter)
			end
		end

feature -- Removal

	delete
			-- mark item as deleted so it will not be saved during the next `store_as' operation
		do
			item.delete
			deleted_count := deleted_count + 1
			on_delete
		end

	compact
			-- Remove any deleted items
		do
			if deleted_count > 0 then
				from start until after loop
					if item.is_deleted then
						remove
					else
						forth
					end
				end
				deleted_count := 0
			end
		end

feature -- Status query

	is_encrypted: BOOLEAN
		do
			Result := not encrypter.is_default
		end

	has_version_mismatch: BOOLEAN
			-- True if data version differs from software version
		do
			if attached reader_writer then
				Result := not reader_writer.is_default_data_version
			elseif file_path.exists then
				Result := header.version /= software_version
			end
		end

feature {NONE} -- Event handler

	on_delete
		deferred
		end

	on_version_mismatch (actual_version: NATURAL)
		do
			reader_writer.set_data_version (actual_version)
		end

feature {NONE} -- Factory

	new_file (a_file_path: like file_path): RAW_FILE
		do
			create Result.make_with_name (a_file_path)
		end

	new_reader_writer: ECD_READER_WRITER [G]
		do
			if is_encrypted then
				if descendants.is_empty then
					create {ECD_ENCRYPTABLE_READER_WRITER [G]} Result.make (encrypter)
				else
					create {ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G]} Result.make (descendants, encrypter)
				end
			elseif descendants.is_empty then
				create Result.make
			else
				create {ECD_MULTI_TYPE_READER_WRITER [G]} Result.make (descendants)
			end
		end

feature {ECD_EDITIONS_FILE} -- Implementation

	put_header (a_file: RAW_FILE)
		do
			a_file.put_natural_32 (software_version)
			a_file.put_integer (undeleted_count)
		end

	retrieve
		local
			i, item_count: INTEGER
		do
			item_count := header.stored_count
			if item_count > 0 then
				encrypter.reset
				if attached new_file (file_path) as l_file then
					l_file.open_read
					if attached reader_writer as l_reader then
						l_reader.set_for_reading

						-- Skip header
						l_file.move (header.size_of)

						from i := 1 until i > item_count or l_file.end_of_file loop
							extend (l_reader.read_item (l_file))
							progress_listener.notify_tick
							i := i + 1
						end
						l_file.close
					end
				end
			end
		ensure
			correct_stored_count: count = header.stored_count
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		local
			i, l_count: INTEGER
		do
			a_file.read_natural 	-- Version
			a_file.read_integer	-- Record count
			l_count := a_file.last_integer
			from until i = l_count or a_file.end_of_file loop
				a_file.read_integer -- Count
				if not a_file.end_of_file then
					a_file.move (a_file.last_integer)
				end
				i := i + 1
			end
			Result := i = undeleted_count
		end

feature {ECD_EDITIONS_FILE} -- Implementation atttributes

	header: ECD_CHAIN_HEADER

	reader_writer: like new_reader_writer

feature {NONE} -- Constants

	Descendants: ARRAY [TYPE [G]]
		do
			create Result.make_empty
		end

end