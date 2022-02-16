note
	description: "[
		This class combines the functionality of classes [$source ECD_CHAIN] and
		[$source ECD_CHAIN_EDITIONS]. The former class can store and load the complete state of
		all chain items, while the latter immediately stores any of the following
		chain editions: `extend', `replace', `remove', `delete'.

		When doing a file retrieval, the last complete state is loaded from `file_path' and then
		all the recent editions are loaded and applied from a separate file: `editions_file_path'.
		The routine `safe_store' stores the complete chain in a temporary file and then does a quick check
		on the integrity of the save by checking all the item headers. Only then is the stored file substituted
		for the previously stored file.
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 14:24:10 GMT (Wednesday 16th February 2022)"
	revision: "25"

deferred class
	ECD_RECOVERABLE_CHAIN [G -> EL_STORABLE create make_default end]

inherit
	ECD_CHAIN [G]
		rename
			delete as chain_delete
		redefine
			make_from_file, delete_file, on_retrieve, rename_base, safe_store, is_closed
		end

	ECD_CHAIN_EDITIONS [G]
		rename
			make as make_editions
		end

	EL_MODULE_NAMING

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

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
			make_editions (Current)
			retrieve
			apply_editions
		end

feature -- Access

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

feature -- Element change

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

	delete_file
		do
			if editions.exists then
				editions.close_and_delete
			end
			Precursor
		end

feature {NONE} -- Implementation

	new_file_path: FILE_PATH
		local
			file_name: STRING; l_name: like name
		do
			l_name := name
			create file_name.make (l_name.count)
			Naming.to_kebab_case_lower (l_name, file_name)
			Result := Directory.App_data + file_name
			Result.add_extension (Default_file_extension)
		end

	on_retrieve
		do
			Precursor
			progress_listener.increase_file_data_estimate (editions_file_path)
		end

feature {NONE} -- Constants

	Closed_editions: INTEGER_8 = 3

	Closed_no_editions: INTEGER_8 = 4

	Closed_safe_store: INTEGER_8 = 1

	Closed_safe_store_failed: INTEGER_8 = 2

	Default_file_extension: ZSTRING
		once
			Result := "dat"
		end

	Trailing_word_count: INTEGER
		-- Number of trailing words to remove from class name when deriving file name
		once
			Result := 0
		end

note
	instructions: "[
		Items must implement the deferred class [$source EL_STORABLE].

		To implement the class you can use any Eiffel container which conforms to [$source CHAIN],
		however it is recommended to use the class [$source ECD_ARRAYED_LIST [EL_STORABLE]] as is offers
		the following functionality:

		* Ability to do complex queries in Eiffel with logial conjunctions using the features of
		[$source EL_QUERYABLE_CHAIN] and [$source EL_QUERY_CONDITION_FACTORY]

		* Ability to store objects using class reflection with safe-guards for the integrity of the
		stores in the form of cyclical reduancy checks on the

		* Ability to export to CSV using class reflective naming
	]"

end