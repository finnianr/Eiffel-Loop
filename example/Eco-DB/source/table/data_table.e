note
	description: "Data table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2023-08-26 11:11:19 GMT (Saturday 26th August 2023)"
	revision: "17"

deferred class
	DATA_TABLE [G -> REFLECTIVELY_STORABLE create make_default end]

inherit
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [G]
		undefine
			new_lio
		redefine
			is_integration_pending, Trailing_word_count, extend, close
		end

	EL_REFLECTIVE_CHAIN_CHECKSUMS [G]

	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make_access
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	SHARED_CUSTOMER_TABLE

feature {NONE} -- Initialization

	make (config: DATABASE_CONFIGURATION)
		do
			make_access
			log.put_labeled_string ("Loading table", name)
			make_from_default_encrypted_file (config.new_encrypter_128)
			log.put_new_line
		end

feature -- Access

	current_working_directory: DIR_PATH
		do
			Result := Directory.current_working
		end

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end

feature -- Status query

	is_integration_pending: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	close
		do
			restrict_access
				Precursor
			end_restriction
		end

	close_and_delete
		do
			restrict_access
				close; delete_file
			end_restriction
		end

	display
		do
			Customer_table.restrict_access
				restrict_access
					if is_empty then
						lio.put_labeled_string (name, "is empty")
						lio.put_new_line
					else
						lio.put_labeled_string ("Listing", name)
						lio.put_new_line

						from start until after loop
							lio.put_character ('[')
							lio.put_integer (index)
							lio.put_string ("] ")
							item.print_fields (lio)
							lio.put_new_line
							forth
						end
					end
				end_restriction
			Customer_table.end_restriction
		end

	import_from_csv
		do
			restrict_access
				import_csv (csv_file_path)
			end_restriction
		end

	import_from_pyxis
		-- import from pyxis folder with matching table name
		do
			restrict_access
				import_pyxis (pyxis_file_path)
			end_restriction
		end

	store_as_csv
		do
			restrict_access
				export_csv (csv_file_path, Utf_8)
			end_restriction
		end

	store_as_pyxis
		do
			restrict_access
				export_pyxis (pyxis_file_path, Utf_8)
			end_restriction
		end

	store_meta_data
		do
			restrict_access
				export_meta_data (meta_data_file_path)
			end_restriction
		end

feature -- Element change

	append (list: ITERABLE [G])
		do
			restrict_access
				across list as row loop
					extend (row.item)
				end
			end_restriction
		end

	extend (a_item: like item)
		do
			restrict_access
				Precursor (a_item)
			end_restriction
		end

feature -- Removal

	delete_customer_linked (customer_key: NATURAL)
		local
			l_count: INTEGER
		do
			restrict_access
				if not is_empty and then attached {CUSTOMER_LINKED} first then
					from start until after loop
						if not item.is_deleted
							and then attached {CUSTOMER_LINKED} item as linked
							and then customer_key = linked.customer_key
						then
							delete; l_count := l_count + 1
						end
						forth
					end
					if l_count > 0 then
						lio.put_integer_field ("Deleted", l_count)
						lio.put_line (" items from linked table " + generator)
					end
				end
			end_restriction
		end

feature {NONE} -- Constants

	Trailing_word_count: INTEGER
		-- Number of trailing words to remove from class name when deriving file name
		once
			Result := 1
		end


end