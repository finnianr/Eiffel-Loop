note
	description: "Export HTML under www sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 14:44:28 GMT (Monday 23rd January 2023)"
	revision: "16"

class
	TB_WWW_XHTML_CONTENT_EXPORTER

inherit
	TB_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		end

	EL_MODULE_LIO

create
	make_from_file

feature -- Constants

	Description: STRING = "Export HTML content from www directory under Thunderbird account"

feature -- Basic operations

	execute
		local
			exporter: TB_XHTML_BODY_EXPORTER; file_path: FILE_PATH
			l_output_dir: DIR_PATH
		do
			across OS.file_list (mail_dir #+ WWW_dir_name, "*.msf") as path loop
				file_path := path.item.without_extension
				lio.put_path_field ("Content %S", file_path)
				lio.put_new_line
				l_output_dir := export_dir #+ file_path.base
				create exporter.make (Current)
				exporter.set_export_steps_prune_count (1) -- prune "www" step
				exporter.export_mails (file_path)
			end
		end

feature {NONE} -- Constants

	WWW_dir_name: ZSTRING
		once
			Result := "www.sbd"
		end

end



