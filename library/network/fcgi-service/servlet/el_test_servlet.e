note
	description: "Test servlet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:08:54 GMT (Sunday 24th December 2023)"
	revision: "5"

class
	EL_TEST_SERVLET

inherit
	FCGI_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve
		do
			response.set_content (Hello_page, Text_type.HTML, {EL_ENCODING_TYPE}.UTF_8)
		end

	Hello_page: STRING
		once
			Result := "[
				<html>
					<head>
						<title>Fast-CGI test</title>
						<style type="text/css">
						<!--
						h1	{text-align:center;
							font-family:Arial, Helvetica, Sans-Serif;
						}
						body	{
							margin-top: 20px;
							text-indent: 20px;
						}
						-->
						</style>
					</head>
					<body bgcolor = "#ffffcc" text = "#000000">
						<h2>Fast-CGI test</h2>
						<p>Hello world</p>
					</body>
				</html>
			]"
		end
end