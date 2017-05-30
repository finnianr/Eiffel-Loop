note
	description: "[
		Chain of storable items which are recoverable from an editions files should the power go off
		on the computer. Items must implement the deferred class 
		[../../../../library/base/utility/memory/el_storable.html EL_STORABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-25 17:45:03 GMT (Monday 25th July 2016)"
	revision: "1"

deferred class
	EL_RECOVERABLE_STORABLE_CHAIN [G -> EL_STORABLE create make_default end]

inherit
	EL_STORABLE_CHAIN [G]
		rename
			delete as chain_delete
		redefine
			make_from_file, rename_file, safe_store
		end

	EL_STORABLE_CHAIN_EDITIONS [G]
		rename
			make as make_editions
		end

feature {NONE} -- Initialization

	make_from_encrypted_file (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			Precursor (a_file_path)
			make_editions (Current)
			retrieve
			apply_editions
		end

feature -- Access

	status: INTEGER_8

feature -- Element change

	rename_file (a_name: ZSTRING)
			--
		do
			Precursor (a_name)
			editions_file.rename_file (editions_file_path)
		end

feature -- Basic operations

	close
			--
		do
			if is_integration_pending then
				safe_store
				if last_store_ok then
					editions_file.close_and_delete
					compact
					status := Closed_safe_store
				else
					editions_file.close
					status := Closed_safe_store_failed
				end

			elseif editions_file.has_editions then
				editions_file.close
				status := Closed_editions
			else
				editions_file.close_and_delete
				status := Closed_no_editions
			end
		end

	safe_store
		do
			reader_writer.set_default_data_version
			Precursor
		end

feature -- Removal

	delete_file
		do
			encrypter.reset
			wipe_out
			editions_file.close_and_delete
			File_system.remove_file (file_path)
			make_from_file (file_path)
		end

feature {NONE} -- Constants

	Closed_safe_store: INTEGER_8 = 1

	Closed_safe_store_failed: INTEGER_8 = 2

	Closed_editions: INTEGER_8 = 3

	Closed_no_editions: INTEGER_8 = 4
end
