note
	description: "Curl option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_CURL_OPTION_CONSTANTS

inherit
	EL_CURL_PLATFORM_OPTION_CONSTANTS

feature -- Version

	libcurl_version: STRING
			-- String representation of LIBCURL_VERSION
		do
			create Result.make_from_c (libcurl_version_pointer)
		end

	libcurl_version_pointer: POINTER
			-- String pointer declared as LIBCURL_VERSION
		external
			"C [macro <curl/curlver.h>]: EIF_POINTER"
		alias
			"LIBCURL_VERSION"
		end

	libcurl_version_major: INTEGER
			-- Declared as LIBCURL_VERSION_MAJOR
		external
			"C [macro <curl/curlver.h>]: EIF_INTEGER"
		alias
			"LIBCURL_VERSION_MAJOR"
		end

	libcurl_version_minor: INTEGER
			-- Declared as LIBCURL_VERSION_MINOR
		external
			"C [macro <curl/curlver.h>]: EIF_INTEGER"
		alias
			"LIBCURL_VERSION_MINOR"
		end

	libcurl_version_patch: INTEGER
			-- Declared as LIBCURL_VERSION_PATCH
		external
			"C [macro <curl/curlver.h>]: EIF_INTEGER"
		alias
			"LIBCURL_VERSION_PATCH"
		end

feature -- Behavior

	CURLOPT_verbose: INTEGER
			-- Declared as CURLOPT_VERBOSE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_VERBOSE"
		end

	CURLOPT_header: INTEGER
			-- Declared as CURLOPT_HEADER.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HEADER"
		end

	CURLOPT_noprogress: INTEGER
			-- Declared as CURLOPT_NOPROGRESS
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_NOPROGRESS"
		end

feature -- Callback

	CURLOPT_writefunction: INTEGER
			-- Declared as CURLOPT_WRITEFUNCTION.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_WRITEFUNCTION"
		end

	CURLOPT_writedata: INTEGER
			-- Declared as CURLOPT_WRITEDATA.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_WRITEDATA"
		end

	CURLOPT_readfunction: INTEGER
			-- Declared as CURLOPT_READFUNCTION.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_READFUNCTION"
		end

	CURLOPT_readdata: INTEGER
			-- Declared as CURLOPT_READDATA.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_READDATA"
		end

	CURLOPT_debugfunction: INTEGER
			-- Declared as CURLOPT_DEBUGFUNCTION.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_DEBUGFUNCTION"
		end

	CURLOPT_progressfunction: INTEGER
			-- Declared as CURLOPT_PROGRESSFUNCTION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROGRESSFUNCTION"
		end

	CURLOPT_progressdata: INTEGER
			-- Declared as CURLOPT_PROGRESSDATA
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROGRESSDATA"
		end

	CURLOPT_writeheader: INTEGER
			-- Declared as CURLOPT_WRITEHEADER.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_WRITEHEADER"
		end

	CURLOPT_headerdata: INTEGER
			-- Declared as CURLOPT_HEADERDATA.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HEADERDATA"
		end

	CURLOPT_headerfunction: INTEGER
			-- Declared as CURLOPT_HEADERFUNCTION.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HEADERFUNCTION"
		end

feature -- Network

	CURLOPT_url: INTEGER
			-- Declared as CURLOPT_URL.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_URL"
		end

	CURLOPT_proxy: INTEGER
			-- Declared as CURLOPT_PROXY.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROXY"
		end

	CURLOPT_proxyport: INTEGER
			-- Declared as CURLOPT_PROXYPORT.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROXYPORT"
		end

	CURLOPT_proxytype: INTEGER
			-- Declared as CURLOPT_PROXYTYPE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROXYTYPE"
		end

	CURLOPT_httpproxytunnel: INTEGER
			-- Declared as CURLOPT_HTTPPROXYTUNNEL.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTPPROXYTUNNEL"
		end

	CURLOPT_interface: INTEGER
			-- Declared as CURLOPT_INTERFACE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_INTERFACE"
		end

	CURLOPT_localport: INTEGER
			-- Declared as CURLOPT_LOCALPORT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_LOCALPORT"
		end

	CURLOPT_localportrange: INTEGER
			-- Declared as CURLOPT_LOCALPORTRANGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_LOCALPORTRANGE"
		end

	CURLOPT_buffersize: INTEGER
			-- Declared as CURLOPT_BUFFERSIZE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_BUFFERSIZE"
		end

	CURLOPT_port: INTEGER
			-- Declared as CURLOPT_PORT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PORT"
		end

	CURLOPT_tcp_nodelay: INTEGER
			-- Declared as CURLOPT_TCP_NODELAY
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TCP_NODELAY"
		end

	CURLOPT_nosignal: INTEGER
			-- Declared as CURLOPT_NOSIGNAL
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_NOSIGNAL"
		end

feature -- Names and Passwords (Authentication)

	CURLOPT_userpwd: INTEGER
			-- Declared as CURLOPT_USERPWD.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_USERPWD"
		end

	CURLOPT_proxyuserpwd: INTEGER
			-- Declared as CURLOPT_PROXYUSERPWD
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROXYUSERPWD"
		end

	CURLOPT_httpauth: INTEGER
			-- Declared as CURLOPT_HTTPAUTH.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTPAUTH"
		end

	curlauth_none: INTEGER
			-- Declared as CURLAUTH_NONE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLAUTH_NONE"
		end

	curlauth_basic: INTEGER
			-- Declared as CURLAUTH_BASIC.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLAUTH_BASIC"
		end

	curlauth_digest: INTEGER
			-- Declared as CURLAUTH_DIGEST.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLAUTH_DIGEST"
		end

	curlauth_any: INTEGER
			-- Declared as CURLAUTH_ANY.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLAUTH_ANY"
		end

	curlauth_anysafe: INTEGER
			-- Declared as CURLAUTH_ANYSAFE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLAUTH_ANYSAFE"
		end

	CURLOPT_proxyauth: INTEGER
			-- Declared as CURLOPT_PROXYAUTH
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PROXYAUTH"
		end

feature -- HTTP

	CURLOPT_autoreferer: INTEGER
			-- Declared as CURLOPT_AUTOREFERER
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_AUTOREFERER"
		end

	CURLOPT_encoding: INTEGER
			-- Declared as CURLOPT_ENCODING.
			-- in future version, this is called CURLOPT_ACCEPT_ENCODING
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_ENCODING"
		end

	CURLOPT_followlocation: INTEGER
			-- Declared as CURLOPT_FOLLOWLOCATION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_FOLLOWLOCATION"
		end

	CURLOPT_unrestricted_auth: INTEGER
			-- Declared as CURLOPT_UNRESTRICTED_AUTH
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_UNRESTRICTED_AUTH"
		end

	CURLOPT_maxredirs: INTEGER
			-- Declared as CURLOPT_MAXREDIRS
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAXREDIRS"
		end

	CURLOPT_put: INTEGER
			-- Declared as CURLOPT_PUT.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_PUT"
		end

	CURLOPT_post: INTEGER
			-- Declared as CURLOPT_POST.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_POST"
		end

	CURLOPT_postfields: INTEGER
			-- Declared as CURLOPT_POSTFIELDS.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_POSTFIELDS"
		end

	CURLOPT_postfieldsize: INTEGER
			-- Declared as CURLOPT_POSTFIELDSIZE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_POSTFIELDSIZE"
		end

	CURLOPT_postfieldsize_large: INTEGER
			-- Declared as CURLOPT_POSTFIELDSIZE_LARGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_POSTFIELDSIZE_LARGE"
		end

	CURLOPT_httppost: INTEGER
			-- Declared as CURLOPT_HTTPPOST.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTPPOST"
		end

	CURLOPT_referer: INTEGER
			-- Declared as CURLOPT_REFERER
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_REFERER"
		end

	CURLOPT_useragent: INTEGER
			-- Declared as CURLOPT_USERAGENT.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_USERAGENT"
		end

	CURLOPT_httpheader: INTEGER
			-- Declared as CURLOPT_HTTPHEADER.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTPHEADER"
		end

	CURLOPT_cookie: INTEGER
			-- Declared as CURLOPT_COOKIE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COOKIE"
		end

	CURLOPT_cookiefile: INTEGER
			-- Declared as CURLOPT_COOKIEFILE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COOKIEFILE"
		end

	CURLOPT_cookiejar: INTEGER
			-- Declared as CURLOPT_COOKIEJAR
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COOKIEJAR"
		end

	CURLOPT_cookiesession: INTEGER
			-- Declared as CURLOPT_COOKIESESSION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COOKIESESSION"
		end

	CURLOPT_cookielist: INTEGER
			-- Declared as CURLOPT_COOKIELIST.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COOKIELIST"
		end

	CURLOPT_httpget: INTEGER
			-- Declared as CURLOPT_HTTPGET
			-- Pass a long. If the long is non-zero, this forces the HTTP request to get back to GET. usable if a POST, HEAD, PUT or a custom request have been used previously using the same curl handle.
			-- When setting CURLOPT_HTTPGET to a non-zero value, it will automatically set CURLOPT_NOBODY to 0 (since 7.14.1).
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTPGET"
		end

	CURLOPT_http_version: INTEGER
			-- Declared as CURLOPT_HTTP_VERSION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTP_VERSION"
		end

	curl_http_version_none: INTEGER
			-- Value used for CURL_HTTP_VERSION.
			-- Let the library to choose the best possible.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_HTTP_VERSION_NONE"
		end

	curl_http_version_1_0: INTEGER
			-- Value used for CURL_HTTP_VERSION.
			-- Use CURL_HTTP_VERSION_1_0
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_HTTP_VERSION_1_0"
		end

	curl_http_version_1_1: INTEGER
			-- Value used for CURL_HTTP_VERSION.
			-- Use CURL_HTTP_VERSION_1_1
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_HTTP_VERSION_1_1"
		end

	CURLOPT_ignore_content_length: INTEGER
			-- Declared as CURLOPT_IGNORE_CONTENT_LENGTH
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_IGNORE_CONTENT_LENGTH"
		end

	CURLOPT_http_content_decoding: INTEGER
			-- Declared as CURLOPT_HTTP_CONTENT_DECODING
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_HTTP_CONTENT_DECODING"
		end

feature -- Protocol

	CURLOPT_transfertext: INTEGER
			-- Declared as CURLOPT_TRANSFERTEXT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TRANSFERTEXT"
		end

	CURLOPT_crlf: INTEGER
			-- Declared as CURLOPT_CRLF
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CRLF"
		end

	CURLOPT_resume_from: INTEGER
			-- Declared as CURLOPT_RESUME_FROM
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_RESUME_FROM"
		end

	CURLOPT_resume_from_large: INTEGER
			-- Declared as CURLOPT_RESUME_FROM_LARGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_RESUME_FROM_LARGE"
		end

	CURLOPT_customrequest: INTEGER
			-- Declared as CURLOPT_CUSTOMREQUEST
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CUSTOMREQUEST"
		end

	CURLOPT_filetime: INTEGER
			-- Declared as CURLOPT_FILETIME
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_FILETIME"
		end

	CURLOPT_nobody: INTEGER
			-- Declared as CURLOPT_NOBODY
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_NOBODY"
		end

	CURLOPT_infilesize: INTEGER
			-- Declared as CURLOPT_INFILESIZE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_INFILESIZE"
		end

	CURLOPT_infilesize_large: INTEGER
			-- Declared as CURLOPT_INFILESIZE_LARGE.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_INFILESIZE_LARGE"
		end

	CURLOPT_upload: INTEGER
			-- Declared as CURLOPT_UPLOAD.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_UPLOAD"
		end

	CURLOPT_maxfilesize: INTEGER
			-- Declared as CURLOPT_MAXFILESIZE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAXFILESIZE"
		end

	CURLOPT_maxfilesize_large: INTEGER
			-- Declared as CURLOPT_MAXFILESIZE_LARGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAXFILESIZE_LARGE"
		end

	CURLOPT_timecondition: INTEGER
			-- Declared as CURLOPT_TIMECONDITION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TIMECONDITION"
		end

	CURLOPT_timevalue: INTEGER
			-- Declared as CURLOPT_TIMEVALUE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TIMEVALUE"
		end

feature -- Connection

	CURLOPT_timeout: INTEGER
			-- Declared as CURLOPT_TIMEOUT.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TIMEOUT"
		end

	CURLOPT_connect_timeout: INTEGER
			-- The number of seconds to wait while trying to connect. Use 0 to wait indefinitely.
			-- Declared as CURLOPT_CONNECTTIMEOUT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CONNECTTIMEOUT"
		end

	CURLOPT_timeout_ms: INTEGER
			-- Declared as CURLOPT_TIMEOUT_MS
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_TIMEOUT_MS"
		end

	CURLOPT_low_speed_limit: INTEGER
			-- Declared as CURLOPT_LOW_SPEED_LIMIT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_LOW_SPEED_LIMIT"
		end

	CURLOPT_low_speed_time: INTEGER
			-- Declared as CURLOPT_LOW_SPEED_TIME
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_LOW_SPEED_TIME"
		end

	CURLOPT_max_send_speed_large: INTEGER
			-- Declared as CURLOPT_MAX_SEND_SPEED_LARGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAX_SEND_SPEED_LARGE"
		end

	CURLOPT_max_recv_speed_large: INTEGER
			-- Declared as CURLOPT_MAX_RECV_SPEED_LARGE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAX_RECV_SPEED_LARGE"
		end

	CURLOPT_maxconnects: INTEGER
			-- Declared as CURLOPT_MAXCONNECTS
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_MAXCONNECTS"
		end

	CURLOPT_fresh_connect: INTEGER
			-- Declared as CURLOPT_FRESH_CONNECT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_FRESH_CONNECT"
		end

	CURLOPT_forbid_reuse: INTEGER
			-- Declared as CURLOPT_FORBID_REUSE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_FORBID_REUSE"
		end

	CURLOPT_connecttimeout: INTEGER
			-- Declared as CURLOPT_CONNECTTIMEOUT.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CONNECTTIMEOUT"
		end

	CURLOPT_ipresolve: INTEGER
			-- Declared as CURLOPT_IPRESOLVE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_IPRESOLVE"
		end

	curl_ipresolve_whatever: INTEGER
			-- Declared as CURL_IPRESOLVE_WHATEVER
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_IPRESOLVE_WHATEVER"
		end

	curl_ipresolve_v4: INTEGER
			-- Declared as CURL_IPRESOLVE_V4
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_IPRESOLVE_V4"
		end

	curl_ipresolve_v6: INTEGER
			-- Declared as CURL_IPRESOLVE_V6
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_IPRESOLVE_V6"
		end

	CURLOPT_connect_only: INTEGER
			-- Declared as CURLOPT_CONNECT_ONLY
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CONNECT_ONLY"
		end

	CURLOPT_use_ssl: INTEGER
			-- Declared as CURLOPT_USE_SSL
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_USE_SSL"
		end

	curlusessl_none: INTEGER
			-- Declared as CURLUSESSL_NONE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLUSESSL_NONE"
		end

	curlusessl_try: INTEGER
			-- Declared as CURLUSESSL_TRY
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLUSESSL_TRY"
		end

	curlusessl_control: INTEGER
			-- Declared as CURLUSESSL_CONTROL
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLUSESSL_CONTROL"
		end

	curlusessl_all: INTEGER
			-- Declared as CURLUSESSL_ALL
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLUSESSL_ALL"
		end

feature -- SSL and Security

	CURLOPT_sslcert: INTEGER
			-- Declared as CURLOPT_SSLCERT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLCERT"
		end

	CURLOPT_sslcerttype: INTEGER
			-- Declared as CURLOPT_SSLCERTTYPE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLCERTTYPE"
		end

	CURLOPT_sslkey: INTEGER
			-- Declared as CURLOPT_SSLKEY
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLKEY"
		end

	CURLOPT_sslkeytype: INTEGER
			-- Declared as CURLOPT_SSLKEYTYPE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLKEYTYPE"
		end

	CURLOPT_keypasswd: INTEGER
			-- Declared as CURLOPT_KEYPASSWD
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_KEYPASSWD"
		end

	CURLOPT_sslengine: INTEGER
			-- Declared as CURLOPT_SSLENGINE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLENGINE"
		end

	CURLOPT_sslengine_default: INTEGER
			-- Declared as CURLOPT_SSLENGINE_DEFAULT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLENGINE_DEFAULT"
		end

	CURLOPT_sslversion: INTEGER
			-- Declared as CURLOPT_SSLVERSION
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSLVERSION"
		end

	CURLOPT_ssl_verifypeer: INTEGER
			-- Declared as CURLOPT_SSL_VERIFYPEER.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSL_VERIFYPEER"
		end

	CURLOPT_cainfo: INTEGER
			-- Declared as CURLOPT_CAINFO
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CAINFO"
		end

	CURLOPT_capath: INTEGER
			-- Declared as CURLOPT_CAPATH
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_CAPATH"
		end

	CURLOPT_ssl_verifyhost: INTEGER
			-- Declared as CURLOPT_SSL_VERIFYHOST
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSL_VERIFYHOST"
		end

	CURLOPT_random_file: INTEGER
			-- Declared as CURLOPT_RANDOM_FILE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_RANDOM_FILE"
		end

	CURLOPT_egdsocket: INTEGER
			-- Declared as CURLOPT_EGDSOCKET
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_EGDSOCKET"
		end

	CURLOPT_ssl_cipher_list: INTEGER
			-- Declared as CURLOPT_SSL_CIPHER_LIST
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSL_CIPHER_LIST"
		end

	CURLOPT_ssl_sessionid_cache: INTEGER
			-- Declared as CURLOPT_SSL_SESSIONID_CACHE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSL_SESSIONID_CACHE"
		end

	CURLOPT_krblevel: INTEGER
			-- Declared as CURLOPT_KRBLEVEL
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_KRBLEVEL"
		end

feature -- SSH

	CURLOPT_ssh_auth_types: INTEGER
			-- Declared as CURLOPT_SSH_AUTH_TYPES
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSH_AUTH_TYPES"
		end

	CURLOPT_ssh_public_keyfile: INTEGER
			-- Declared as CURLOPT_SSH_PUBLIC_KEYFILE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSH_PUBLIC_KEYFILE"
		end

	CURLOPT_ssh_private_keyfile: INTEGER
			-- Declared as CURLOPT_SSH_PRIVATE_KEYFILE
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_SSH_PRIVATE_KEYFILE"
		end

feature -- Status report

	is_valid (v: INTEGER): BOOLEAN
			-- If `v' value valid?
		do
			Result := all_options.has (v)
		end

	is_valid_http_command (v: INTEGER): BOOLEAN
		do
			Result := (<< CURLOPT_header, CURLOPT_httpget, CURLOPT_post >>).has (v)
		end

	all_options: ARRAY [INTEGER]
		do
			Result := <<
					CURLOPT_verbose,
					CURLOPT_header,
					CURLOPT_noprogress,
					CURLOPT_writefunction,
					CURLOPT_writedata,
					CURLOPT_readfunction,
					CURLOPT_readdata,
					CURLOPT_debugfunction,
					CURLOPT_progressfunction,
					CURLOPT_progressdata,
					CURLOPT_writeheader,
					CURLOPT_url,
					CURLOPT_proxy,
					CURLOPT_proxyport,
					CURLOPT_proxytype,
					CURLOPT_httpproxytunnel,
					CURLOPT_interface,
					CURLOPT_localport,
					CURLOPT_localportrange,
					CURLOPT_buffersize,
					CURLOPT_port,
					CURLOPT_tcp_nodelay,
					CURLOPT_userpwd,
					CURLOPT_proxyuserpwd,
					CURLOPT_httpauth,
					CURLOPT_proxyauth,
					CURLOPT_autoreferer,
					CURLOPT_encoding,
					CURLOPT_followlocation,
					CURLOPT_unrestricted_auth,
					CURLOPT_maxredirs,
					CURLOPT_put,
					CURLOPT_post,
					CURLOPT_postfields,
					CURLOPT_postfieldsize,
					CURLOPT_postfieldsize_large,
					CURLOPT_httppost,
					CURLOPT_referer,
					CURLOPT_useragent,
					CURLOPT_httpheader,
					CURLOPT_cookie,
					CURLOPT_cookiefile,
					CURLOPT_cookiejar,
					CURLOPT_cookiesession,
					CURLOPT_cookielist,
					CURLOPT_httpget,
					CURLOPT_http_version,
					CURLOPT_ignore_content_length,
					CURLOPT_http_content_decoding,
					CURLOPT_transfertext,
					CURLOPT_crlf,
					CURLOPT_resume_from,
					CURLOPT_resume_from_large,
					CURLOPT_customrequest,
					CURLOPT_filetime,
					CURLOPT_nobody,
					CURLOPT_infilesize,
					CURLOPT_infilesize_large,
					CURLOPT_upload,
					CURLOPT_maxfilesize,
					CURLOPT_maxfilesize_large,
					CURLOPT_timecondition,
					CURLOPT_timevalue,
					CURLOPT_timeout,
					CURLOPT_timeout_ms,
					CURLOPT_low_speed_limit,
					CURLOPT_low_speed_time,
					CURLOPT_max_send_speed_large,
					CURLOPT_max_recv_speed_large,
					CURLOPT_maxconnects,
					CURLOPT_fresh_connect,
					CURLOPT_forbid_reuse,
					CURLOPT_connecttimeout,
					CURLOPT_ipresolve,
					CURLOPT_connect_only,
					CURLOPT_use_ssl,
					CURLOPT_sslcert,
					CURLOPT_sslcerttype,
					CURLOPT_sslkey,
					CURLOPT_sslkeytype,
					CURLOPT_keypasswd,
					CURLOPT_sslengine,
					CURLOPT_sslengine_default,
					CURLOPT_sslversion,
					CURLOPT_ssl_verifypeer,
					CURLOPT_cainfo,
					CURLOPT_capath,
					CURLOPT_ssl_verifyhost,
					CURLOPT_random_file,
					CURLOPT_egdsocket,
					CURLOPT_ssl_cipher_list,
					CURLOPT_ssl_sessionid_cache,
					CURLOPT_krblevel,
					CURLOPT_ssh_auth_types,
					CURLOPT_ssh_public_keyfile,
					CURLOPT_ssh_private_keyfile,
					CURLOPT_headerdata,
					CURLOPT_headerfunction
				>>
		end

end
