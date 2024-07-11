note
	description: "[
		Chain of storable items which can be saved to and read from a file. The chain has the following
		features:
		
		* Support for AES encryption
		* Ability to mark items for deletion without actually having to remove them immediately. This allows
		implementations like class ${ECD_REFLECTIVE_RECOVERABLE_CHAIN} to support field indexing.
		* Ability to store software version information which is available to the item
		implementing ${EL_STORABLE}.
	]"
	descendants: "See end of class"
	notes: "See end of class"
	to_do: "[
		Change `delete' routine to replace item with a shared default deleted item. This will allow deleted item to
		be garbage collected
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 9:28:31 GMT (Thursday 11th July 2024)"
	revision: "37"

deferred class
	ECD_STORABLE_CHAIN  [G -> EL_STORABLE create make_default end]

inherit
	ECD_CHAIN [G]
		export
			{ECD_EDITIONS_FILE} reader_writer
		redefine
			make_default, on_open_read, on_open_write, undeleted_count
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

feature {NONE} -- Initialization

	make_default
		do
			if not attached encrypter then
				encrypter := Default_encrypter
			end
			Precursor {ECD_CHAIN}
		end

	make_from_file_and_encrypter (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

feature -- Measurement

	deleted_count: INTEGER

	store_tick_count: INTEGER
		do
			Result := undeleted_count
		end

	undeleted_count: INTEGER
		do
			Result := count - deleted_count
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

	delete
			-- mark item as deleted so it will not be saved during the next `store_as' operation
		do
			item.delete
			deleted_count := deleted_count + 1
			on_delete
		end

feature -- Status query

	has_version_mismatch: BOOLEAN
			-- True if data version differs from software version
		do
			if attached reader_writer then
				Result := not reader_writer.is_default_data_version
			elseif file_path.exists then
				Result := header.version /= software_version
			end
		end

	is_encrypted: BOOLEAN
		do
			Result := not encrypter.is_default
		end

feature {NONE} -- Event handler

	on_open_read, on_open_write
		do
			encrypter.reset
		end

feature {NONE} -- Factory

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

	new_stored_item (reader: like new_reader_writer; file: RAW_FILE): like item
		do
			Result := reader.read_item (file)
		end

feature {NONE} -- Implementation

	write_item (writer: like new_reader_writer; file: RAW_FILE)
		do
			if not item.is_deleted then
				writer.write (item, file)
				progress_listener.notify_tick
			end
		end

feature {NONE} -- Constants

	Descendants: ARRAY [TYPE [G]]
		do
			create Result.make_empty
		end

note
	notes: "[
		Items must implement either the
		class ${EL_STORABLE} or ${EL_REFLECTIVELY_SETTABLE_STORABLE}.

		The descendant class ${ECD_RECOVERABLE_CHAIN} can be used to implement a proper
		indexed transactional database when used in conjunction with class ${ECD_REFLECTIVE_RECOVERABLE_CHAIN}.

		The routine `safe_store' stores the complete chain in a temporary file and then does a quick check
		on the integrity of the save by checking all the item headers. Only then is the stored file substituted
		for the previously stored file.
	]"
	descendants: "[
			ECD_STORABLE_CHAIN* [G -> EL_STORABLE create make_default end]
				${ECD_STORABLE_ARRAYED_LIST [G -> EL_STORABLE create make_default end]}
				${EL_TRANSLATION_ITEMS_LIST}
				${ECD_RECOVERABLE_CHAIN* [G -> EL_STORABLE create make_default end]}
					${EL_COMMA_SEPARATED_WORDS_LIST}
					${AIA_STORABLE_CREDENTIAL_LIST}
					${ECD_REFLECTIVE_RECOVERABLE_CHAIN* [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]}
						${COUNTRY_DATA_TABLE}
	]"
end