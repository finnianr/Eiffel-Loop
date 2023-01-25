note
	description: "Export HTML under www sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-25 17:46:43 GMT (Wednesday 25th January 2023)"
	revision: "17"

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
			exporter: TB_XHTML_BODY_EXPORTER; mails_path: FILE_PATH
			l_output_dir: DIR_PATH
		do
			across OS.file_list (mail_dir #+ WWW_dir_name, "*.msf") as path loop
				mails_path := path.item.without_extension
				lio.put_path_field ("Content %S", mails_path)
				lio.put_new_line
				l_output_dir := export_dir #+ mails_path.base
				create exporter.make (Current)
				exporter.set_export_steps_prune_count (1) -- prune "www" step
				exporter.export_mails (new_email_list (mails_path))
			end
		end

feature {NONE} -- Constants

	WWW_dir_name: ZSTRING
		once
			Result := "www.sbd"
		end

end


