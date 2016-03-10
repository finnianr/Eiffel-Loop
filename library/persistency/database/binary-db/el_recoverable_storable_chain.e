note
	description: "Summary description for {EL_RECOVERABLE_BINARY_STORABLE_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-27 13:51:20 GMT (Saturday 27th September 2014)"
	revision: "4"

deferred class
	EL_RECOVERABLE_STORABLE_CHAIN [G -> EL_STORABLE create make_default end]

inherit
	EL_STORABLE_CHAIN [G]
		rename
			delete as chain_delete
		redefine
			make_from_file, rename_file
		end

	EL_STORABLE_CHAIN_EDITIONS [G]
		rename
			make as make_editions
		end

feature {NONE} -- Initialization

	make_from_encrypted_file (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_version: like version)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path, a_version)
		end

	make_from_file (a_file_path: EL_FILE_PATH; a_version: like version)
		do
			log.enter_no_header ("make_from_file")
			Precursor (a_file_path, a_version)
			make_editions (Current)
			retrieve
			apply_editions
			if editions_file.is_read_complete then
				log.put_integer_field ("Applied", editions_file.count); log.put_string (" editions")
			else
				log_or_io.put_line ("Editions file is incomplete")
				log_or_io.put_integer_field ("Missing editions", editions_file.count - editions_file.read_count)
			end
			log_or_io.put_new_line
			log_or_io.put_new_line
			log.exit_no_trailer
		end

feature -- Element change

	rename_file (a_name: ASTRING)
			--
		do
			Precursor (a_name)
			editions_file.rename_file (editions_file_path)
		end

feature -- Basic operations

	close
			--
		do
			log.enter_no_header ("close")
			log_or_io.put_path_field ("Closing", file_path)
			log_or_io.put_new_line
			if is_time_to_store then
				safe_store
				if last_store_ok then
					editions_file.close_and_delete
					log_or_io.put_line ("Stored editions")
					compact
				else
					log_or_io.put_line ("Failed to store editions")
					editions_file.close
				end

			elseif editions_file.has_editions then
				editions_file.close
			else
				log_or_io.put_line ("No editions made")
				editions_file.close_and_delete
			end
			log.put_new_line
			log.exit_no_trailer
		end

feature -- Removal

	delete_file
		do
			encrypter.reset
			wipe_out
			editions_file.close_and_delete
			File_system.remove_file (file_path)
			make_from_file (file_path, version)
		end

end
