note
	description: "Change HTTP SSL and other settings with CURL options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 15:14:43 GMT (Saturday 15th November 2025)"
	revision: "3"

deferred class
	EL_HTTP_CONNECTION_OPTIONS

inherit
	EL_HTTP_CONNECTION_BASE
		rename
			is_valid as is_valid_option_constant
		export
			{EL_HTTP_COMMAND} curl
			{ANY} content, is_valid_http_command
		end

feature -- Status setting

	disable_verbose
		do
			curl.set_boolean_option (CURLOPT_verbose, False)
		end

	enable_verbose
		do
			curl.set_boolean_option (CURLOPT_verbose, True)
		end

	reset_cookie_session
		-- Mark this as a new cookie "session". It will force libcurl to ignore all cookies it is about to load
		-- that are "session cookies" from the previous session. By default, libcurl always stores and loads all cookies,
		-- independent if they are session cookies or not. Session cookies are cookies without expiry date and they are meant
		-- to be alive and existing for this "session" only.
		do
			curl.set_boolean_option (CURLOPT_cookiesession, True)
		end

	set_redirection_follow
		do
			curl.set_boolean_option (CURLOPT_followlocation, True)
		end

feature -- SSL settings

	set_certificate_authority_info (a_cacert_path: FILE_PATH)
		do
			curl.set_string_option (CURLOPT_cainfo, a_cacert_path)
		end

	set_certificate_authority_info_default
		-- set certificate authority from environment variable `CURL_CA_BUNDLE' if it exists
		do
			if attached execution.item ("CURL_CA_BUNDLE") as ca_path and then ca_path.count > 0 then
				set_certificate_authority_info (ca_path)
			end
		end

	set_certificate_verification (flag: BOOLEAN)
		-- Curl verifies whether the certificate is authentic,
		-- i.e. that you can trust that the server is who the certificate says it is.
		do
			curl.set_boolean_option (CURLOPT_ssl_verifypeer, flag)
		end

	set_hostname_verification (flag: BOOLEAN)
		-- If the site you're connecting to uses a different host name that what
		-- they have mentioned in their server certificate's commonName (or
		-- subjectAltName) fields, libcurl will refuse to connect.
		do
			curl.set_boolean_option (CURLOPT_ssl_verifyhost, flag)
		end

	set_ssl_version (version: INTEGER)
		-- 0 is default
		require
			valid_ssl_version: valid_ssl_version (version)
		do
			curl.set_ssl_version (version)
		end

	set_tls_version (version: INTEGER)
		require
			valid_unix_version: {PLATFORM}.is_unix implies valid_tls_version (version)
			valid_windows_version: {PLATFORM}.is_windows implies 0 = version
		do
			curl.set_tls_version (version)
		end

	set_tls_version_1_x
		do
			curl.set_tls_version_1_x
		end

feature -- Status query

	valid_ssl_version (version: INTEGER): BOOLEAN
		do
			inspect version
				when 0, 2, 3 then
					Result := True
			else
			end
		end

	valid_tls_version (version: INTEGER): BOOLEAN
		do
			inspect version
				when 0, 1_0, 1_1, 1_2 then
					Result := True
			else
			end
		end

end