note
	description: "Servlet service that runs in a background worker thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 19:55:13 GMT (Friday 8th July 2016)"
	revision: "6"

deferred class
	EL_BACKGROUND_FAST_CGI_SERVLET_SERVICE

inherit
	EL_FAST_CGI_SERVLET_SERVICE
		export
			{NONE} set_end_application
		redefine
			make, initialize, finish
		end

	EL_COMMAND
		rename
			execute as launch
		select
			launch
		end

	EL_LOGGED_IDENTIFIED_THREAD
		rename
			make_default as make_thread
		redefine
			stop
		end

	EL_SHARED_THREAD_MANAGER

feature {EL_SERVLET_SUB_APPLICATION} -- Initialization

	make (config_dir: EL_DIR_PATH; config_name: ZSTRING)
		do
			Precursor (config_dir, config_name)
			set_name (config_name)
			make_thread
		end

feature -- Status change

	stop
			-- stop thread
		do
			Precursor
			call_stop_servlet -- Wakes up port listener so we can stop service
		end

feature {NONE} -- Implementation

	call_stop_servlet
		local
			localhost_root: EL_DIR_URI_PATH; localhost_uri: EL_FILE_URI_PATH
			web: EL_HTTP_CONNECTION; retry_count: INTEGER
		do
			localhost_root := protocol + "://localhost" + Servlet_root_path
			localhost_uri := localhost_root + stop_servlet_path

			create web.make
			web.open (localhost_uri)
			from retry_count := 1 until retry_count > 2 loop
				lio.put_labeled_string ("Servlet", localhost_uri.to_string); lio.put_string (" ")
				web.read_string
				if web.has_error then
					lio.put_string ("FAILED retrying..")
					retry_count := retry_count + 1
				else
					lio.put_string (web.last_string)
					retry_count := retry_count + 10
				end
				lio.put_new_line
			end
			web.close
		end

	finish
			-- finish serving request
		do
			if state = State_stopping and then servlets.found_item = stop_servlet then
				end_application := True
			end
			Precursor
		end

	initialize
		do
			Precursor
			stop_servlet_path := servlets.current_keys [1]
			stop_servlet_path.set_base ("stop")
			create stop_servlet.make (config)
			servlets [stop_servlet_path] := stop_servlet
		end

	protocol: ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Default_protocol: ZSTRING
		once
			Result := "http"
		end

	Secure_protocol: ZSTRING
		once
			Result := "https"
		end

	Servlet_root_path: EL_DIR_PATH
			-- Set this to match the path specified in directory handler rule for web server configuration.
			-- The default value only works if the match rule is a regular expression.
			--
		once
			Result := "/"
		end

	stop_servlet: EL_OK_SERVLET

	stop_servlet_path: EL_FILE_PATH

end