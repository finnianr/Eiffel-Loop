note
	description: "[
		A ${ECD_STORABLE_CHAIN} that is recoverable despite write any errors. 
		The former class can store and load the complete state of all chain items, 
		while this class immediately stores any of the following
		chain editions: `extend', `replace', `remove', `delete'.

		When doing a file retrieval, the last complete state is loaded from `file_path' and then
		all the recent editions are loaded and applied from a separate file: `editions_file_path'.
		The routine `safe_store' stores the complete chain in a temporary file and then does a quick check
		on the integrity of the save by checking all the item headers. Only then is the stored file substituted
		for the previously stored file.
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 8:19:39 GMT (Thursday 11th July 2024)"
	revision: "36"

deferred class
	ECD_RECOVERABLE_CHAIN [G -> EL_STORABLE create make_default end]

inherit
	ECD_STORABLE_CHAIN [G]
		rename
			delete as chain_delete
		redefine
			delete_file, header, make_default, make_from_file, rename_base, safe_store, is_closed
		end

	EL_MODULE_LIO; EL_MODULE_NAMING

	ECD_CONSTANTS

feature {NONE} -- Initialization

	make_from_default_encrypted_file (a_encrypter: EL_AES_ENCRYPTER)
		do
			make_from_encrypted_file (new_file_path, a_encrypter)
		end

	make_from_default_file
		do
			make_from_file (new_file_path)
		end

	make_from_encrypted_file (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

	make_from_file (a_file_path: FILE_PATH)
		do
			Precursor (a_file_path)
			editions.set_attributes (editions_file_path)
			apply_editions
		end

	make_default
		do
			Precursor
			if is_encrypted then
				create {ECD_ENCRYPTABLE_EDITIONS_FILE [G]} editions.make (Current)
			else
				create editions.make (Current)
			end
		end

feature -- Access

	active_list: EL_ARRAYED_LIST [G]
		-- list of items that are not deleted
		do
			create Result.make_from_if (Current, agent is_active)
		end

	name: STRING
		do
			-- Use {Current} do prevent invariant violiation
			Result := Naming.class_as_snake_upper ({like Current}, 0, Trailing_word_count)
		end

	status: INTEGER_8

feature -- Status query

	is_closed: BOOLEAN
		do
			Result := editions.is_closed
		end

	is_integration_pending: BOOLEAN
			-- True when it becomes necessary to integrate editions into main list (chain) by calling `store'
		do
			Result := editions.kilo_byte_count > Compaction_threshold
						or else has_version_mismatch
						or else editions.has_checksum_mismatch
							-- A checksum mismatch indicates that the editions
							-- have become corrupted somewhere, so save
							-- what's good and start a clean editions.
		end


feature -- Element change

	extend (a_item: like item)
			--
		do
			chain_extend (a_item)
			if editions.is_open_write then
				editions.put_edition (editions.Code_extend, a_item)
			end
		end

	replace (a_item: like item)
			--
		do
			chain_replace (a_item)
			if editions.is_open_write then
				editions.put_edition (editions.Code_replace, a_item)
			end
		end

feature -- Status change

	reopen
		do
			editions.reopen
		end

feature -- Basic operations

	close
			--
		do
			if is_integration_pending then
				safe_store
				if last_store_ok and editions.is_reset then
					editions.close_and_delete
					status := Closed_safe_store
				else
					editions.close
					status := Closed_safe_store_failed
				end
			elseif not editions.is_reset then
				editions.close
				status := Closed_editions
			else
				editions.close_and_delete
				status := Closed_no_editions
			end
			-- This is so that incremental backups will work
			if editions.exists and then not editions.is_bigger then
				editions.restore_date
			end
		end

	print_status
		do
			inspect status
				when Closed_safe_store then
					lio.put_line ("Stored editions")

				when Closed_safe_store_failed then
					lio.put_line ("Failed to store editions")

				when Closed_no_editions then
					lio.put_line ("Closed editions")

				when Closed_editions then
					lio.put_line ("No editions made")

			else
			end
		end

	rename_base (new_name: READABLE_STRING_GENERAL; preserve_extension: BOOLEAN)
		-- rename basename of files preserving the extension if `preserve_extension' is true
		do
			Precursor (new_name, preserve_extension)
			if editions.exists then
				editions.rename_file (editions_file_path)
			else
				editions.set_path (editions_file_path)
			end
		ensure then
			editions_renamed: editions_file_path.same_base (editions.path.components.last.name)
		end

	safe_store
		do
			reader_writer.set_default_data_version
			Precursor
			if last_store_ok then
				editions.close_and_delete
				compact
				editions.reopen
			end
		ensure then
			editions_stripped: last_store_ok implies editions.is_reset
		end

feature -- Removal

	delete
		do
			if editions.is_open_write then
				editions.put_edition (editions.Code_delete, item)
			end
			chain_delete
		end

	delete_file
		do
			if editions.exists then
				editions.close_and_delete
			end
			Precursor
		end

	remove
		obsolete
			"Better to use `delete' as `remove' will interfere with the proper working of field indexing tables"
			--
		do
			if editions.is_open_write then
				editions.put_edition (editions.Code_remove, item)
			end
			chain_remove
		end

feature {NONE} -- Implementation

	is_active (v: G): BOOLEAN
		do
			Result := not v.is_deleted
		end

	apply_editions
		do
			editions.apply
		ensure
			valid_count: count = old count + editions.delta_count
		end

	editions_file_path: FILE_PATH
		do
			Result := header.editions_path (file_path)
		end

	new_file_path: FILE_PATH
		local
			file_name: STRING; l_name: like name
		do
			l_name := name
			create file_name.make (l_name.count)
			Naming.to_kebab_case_lower (l_name, file_name)
			Result := Default_data_dir + file_name
			Result.add_extension (Default_file_extension)
		end

feature {NONE} -- Deferred

	chain_extend (a_item: like item)
			--
		deferred
		end

	chain_remove
			--
		deferred
		end

	chain_replace (a_item: like item)
			--
		deferred
		end

feature {ECD_EDITIONS_FILE} -- Implementation atttributes

	editions: ECD_EDITIONS_FILE [G]
		-- editions file

	header: ECD_RECOVERABLE_CHAIN_HEADER

feature {NONE} -- Constants

	Compaction_threshold: REAL
			-- Minimum file size of editions in kb to trigger compaction
		once
			Result := 50 -- Kb
		end

	Trailing_word_count: INTEGER
		-- Number of trailing words to remove from class name when deriving file name
		once
			Result := 0
		end

note
	instructions: "[
		Items must implement the deferred class ${EL_STORABLE}.

		To implement the class you can use any Eiffel container which conforms to ${CHAIN},
		however it is recommended to use the class ${ECD_ARRAYED_LIST [EL_STORABLE]} as is offers
		the following functionality:

		* Ability to do complex queries in Eiffel with logial conjunctions using the features of
		${EL_QUERYABLE_CHAIN} and ${EL_QUERY_CONDITION_FACTORY}

		* Ability to store objects using class reflection with safe-guards for the integrity of the
		stores in the form of cyclical reduancy checks on the

		* Ability to export to CSV using class reflective naming
	]"

end