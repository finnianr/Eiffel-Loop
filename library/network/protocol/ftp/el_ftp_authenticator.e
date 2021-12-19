note
	description: "FTP user authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:28:29 GMT (Sunday 19th December 2021)"
	revision: "3"

class
	EL_FTP_AUTHENTICATOR

inherit
	ANY

	EL_MODULE_TUPLE

	EL_MODULE_USER_INPUT

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_ftp: like ftp)
		do
			ftp := a_ftp
			create username.make (0); create password.make (0)
			credentials := << username, password >>
			input_prompts := Default_prompts
		end

feature -- Access

	password: STRING
			-- Optional password

	username: STRING
			-- Optional username

feature -- Status query

	authenticated: BOOLEAN

feature -- Status change

	force_authenticated
		-- force authenticated status
		do
			authenticated := True
		end

feature -- Basic operations

	try_login
		local
			line, credential: STRING; done: BOOLEAN
		do
			if not authenticated then
				across prompt_list as list loop
					from done := False until done loop
						credential := credentials [list.cursor_index]
						line := User_input.line (list.item)
						-- Allow previous credential to be reused by entering empty line
						if line.is_empty and credential.count > 0 then
							done := True

						elseif line.count > 0 then
							credential.share (line)
							done := True
						else
							-- credential still not entered
						end
					end
					lio.put_new_line
				end
			end
			ftp.set_username (username)
			ftp.set_password (password)
			ftp.authenticate
			if not authenticated then
				-- only need to authenticate once, then reuse same credentials
				authenticated := ftp.is_logged_in
			end
		end

feature -- Element change

	set_input_prompts (user_name_and_password: READABLE_STRING_GENERAL)
		require
			has_delimiter: user_name_and_password.has (',')
		do
			input_prompts := user_name_and_password
		end

feature {NONE} -- Implementation

	prompt_list: EL_ZSTRING_LIST
		do
			create Result.make_comma_split (input_prompts)
		end

feature {NONE} -- Internal attributes

	credentials: ARRAY [STRING]

	ftp: EL_FTP_PROTOCOL

	input_prompts: READABLE_STRING_GENERAL

feature {NONE} -- Constants

	Default_prompts: READABLE_STRING_GENERAL
		once
			Result := "Enter FTP access username, Enter passprase"
		end

end