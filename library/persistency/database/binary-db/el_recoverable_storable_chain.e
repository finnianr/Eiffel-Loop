note
	description: "Summary description for {EL_RECOVERABLE_BINARY_STORABLE_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:00 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_RECOVERABLE_STORABLE_CHAIN [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	EL_STORABLE_CHAIN [G]
		redefine
			make_from_file, rename_file
		end

	EL_STORABLE_CHAIN_EDITIONS [G]
		rename
			make as make_editions
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH; a_version: like version)
		do
			Precursor (a_file_path, a_version)
			make_editions (Current)
			retrieve
			apply_editions
		end

feature -- Element change

	rename_file (a_name: EL_ASTRING)
			--
		do
			Precursor (a_name)
			editions_file.rename_file (editions_file_path.unicode)
		end

feature -- Basic operations

	close
			--
		do
			log.enter ("close")
			if is_time_to_store then
				safe_store
				if last_store_ok then
					editions_file.close_and_delete
					log_or_io.put_line ("Stored editions")
				else
					log_or_io.put_line ("Failed to store editions")
					editions_file.close
				end

			elseif not editions_file.has_editions then
				log_or_io.put_line ("No editions made")
				editions_file.close_and_delete
			end
			log.exit
		end

end