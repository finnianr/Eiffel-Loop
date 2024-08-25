note
	description: "[
		Read folder of Thunderbird HTML email content and collects email headers in `field_table'
		HTML content is collected in line list `html_lines' and then event handler `on_email_end' is
		called, before processing the next email.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:30:54 GMT (Sunday 25th August 2024)"
	revision: "24"

deferred class
	TB_FOLDER_EXPORTER

inherit
	EL_MODULE_FILE_SYSTEM

	TB_CONSTANTS

feature {NONE} -- Initialization

	make (a_config: like config)
			--
		do
			make_default
			config := a_config
		end

	make_default
		do
			create output_dir
			create output_file_path
		end

feature -- Access

	output_dir: DIR_PATH

	export_steps_prune_count: INTEGER
		-- number of steps to remove from tail of `export_steps'

feature -- Element change

	set_export_steps_prune_count (a_count: INTEGER)
		do
			export_steps_prune_count := a_count
		end

feature -- Basic operations

	export_mails (email_list: TB_EMAIL_LIST)
		local
			email: TB_EMAIL
		do
			output_dir := config.export_dir #+ export_steps (email_list.source_path)
			File_system.make_directory (output_dir)

			across email_list as list loop
				email := list.item
				set_output_file_path (email.subject_decoded)
				write_lines (email)
			end
		end

feature {NONE} -- Implementation

	export_steps (mails_path: FILE_PATH): EL_PATH_STEPS
		do
			Result := config.export_steps (mails_path)
			if export_steps_prune_count.to_boolean then
				Result.remove_tail (export_steps_prune_count)
			end
		end

	new_content_lines (email: TB_EMAIL): EL_ZSTRING_LIST
		do
			create Result.make_with_lines (email.content)
		end

	new_html_lines (email: TB_EMAIL): TB_HTML_LINES
		do
			create Result.make (new_content_lines (email))
		end

feature {NONE} -- Deferred

	set_output_file_path (subject_line: ZSTRING)
		deferred
		end

	write_lines (email: TB_EMAIL)
		-- Called after each email headers and content is collected and ready for processing
		deferred
		end

feature {NONE} -- Internal attributes

	config: TB_ACCOUNT_READER

	output_file_path: FILE_PATH

end