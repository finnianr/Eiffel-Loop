note
	description: "FTP user authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_FTP_AUTHENTICATOR

obsolete
	"Authentication now responsibility of EL_FTP_CONFIGURATION"

inherit
	ANY

	EL_MODULE_TUPLE

	EL_MODULE_USER_INPUT

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			create username.make_empty; create password.make_empty
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

	try_login (ftp: EL_FTP_PROTOCOL)
		local
			line, credential: STRING; done: BOOLEAN
		do
			if authenticated then
				authenticate (ftp)
			else
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
				authenticate (ftp)
			end
		end

feature -- Element change

	set_input_prompts (user_name_and_password: READABLE_STRING_GENERAL)
		require
			has_delimiter: user_name_and_password.has (',')
		do
			input_prompts := user_name_and_password
		end

	set_username_passsword (config: EL_FTP_CONFIGURATION)
		require
			authenticated: config.is_authenticated
		do
			password := config.url.password
			username := config.url.username
			force_authenticated
		end

feature {NONE} -- Implementation

	authenticate (ftp: EL_FTP_PROTOCOL)
		do
			ftp.set_username (username)
			ftp.set_password (password)
			ftp.authenticate
			if not authenticated then
				-- only need to authenticate once, then reuse same credentials
				authenticated := ftp.is_logged_in
			end
		end

	prompt_list: EL_ZSTRING_LIST
		do
			create Result.make_comma_split (input_prompts)
		end

feature {NONE} -- Internal attributes

	credentials: ARRAY [STRING]

	input_prompts: READABLE_STRING_GENERAL

feature {NONE} -- Constants

	Default_prompts: READABLE_STRING_GENERAL
		once
			Result := "Enter FTP access username, Enter passprase"
		end

end
