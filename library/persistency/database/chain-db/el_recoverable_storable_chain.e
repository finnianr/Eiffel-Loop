note
	description: "[
		Chain of storable items which are recoverable from an editions files should the power go off
		on the computer. Items must implement the deferred class [$source EL_STORABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-24 12:32:45 GMT (Sunday 24th December 2017)"
	revision: "4"

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

	EL_MODULE_NAMING

	EL_MODULE_DIRECTORY

feature {NONE} -- Initialization

	make_from_default_encrypted_file (a_encrypter: EL_AES_ENCRYPTER)
		do
			make_from_encrypted_file (new_file_path, a_encrypter)
		end

	make_from_encrypted_file (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

	make_from_default_file
		do
			make_from_file (new_file_path)
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

	name: STRING
		do
			Result := Naming.crop_as_upper_snake_case (generator, 0, Suffix_count)
		end

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

feature {NONE} -- Implementation

	new_file_path: EL_FILE_PATH
		local
			file_name: STRING; l_name: like name
		do
			l_name := name
			create file_name.make (l_name.count)
			Naming.to_kebab_lower_case (l_name, file_name)
			Result := Directory.User_data + file_name
			Result.add_extension (Default_file_extension)
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

	Suffix_count: INTEGER
		-- Class name suffix count
		once
			Result := 0
		end

end
