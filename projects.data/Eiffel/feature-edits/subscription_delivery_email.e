note
	description: "Summary description for {SUBSCRIPTION_PACK_EMAIL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUBSCRIPTION_DELIVERY_EMAIL

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			output_path as email_path
		end

	EL_MODULE_BASE_64

	EL_MODULE_LOG

	EL_MODULE_LOCALE

	EL_MODULE_DIRECTORY

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make (a_pack: like pack)
		do
			pack := a_pack
			create content.make (pack, subject)
			make_from_file (Directory.temporary + a_pack.customer.email)
			email_path.add_extension ("eml")
		end

@f bo

	send
		local
			file_out: PLAIN_TEXT_FILE
		do
			log.enter ("send")
			create file_out.make_open_write (email_path)
			across to_utf_8_xml.split ('%N') as line loop
				file_out.put_string (line.item)
				file_out.put_character ('%R')
				file_out.put_new_line
			end
			file_out.close
			Sendmail_command.put_variables (<<
				[Var_address, pack.customer.email],
				[Var_email_path, email_path]
			>>)
			Sendmail_command.execute
			File_system.delete (email_path)
			log.exit
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["subject_utf8_base64", 	agent: STRING do Result := Base_64.encoded (subject.to_utf8) end],

				["address", 					agent: ASTRING do Result := pack.customer.email end],
				["customer_name", 			agent: ASTRING do Result := pack.customer.name end],
				["attachment_file_name", 	agent: ASTRING do Result := content.attachment_file_name end],

				["content", 					agent: like content do Result := content end],
				["pack", 						agent: like pack do Result := pack end]
			>>)
		end

@f {im

	subject: ASTRING
		do
			Result := Locale.in (pack.language) * "{subscription-email-subject}"
		end

feature {NONE} -- Attributes

	content: SUBSCRIPTION_EMAIL_CONTENT

	pack: SUBSCRIPTION_PACK

@f {co

	Sendmail_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				sendmail -O DeliveryMode=background $address < "$email_path"
			]")
		end

	Template: STRING
			-- Template indent is fine so long as blank lines have tabs
			-- Could the trouble be in el_toolkit text editing?
		once
			Result := "[
				From: Hex 11 Software <noreply@myching.co>
				To: $customer_name <$address>
				MIME-Version: 1.0
				Subject: =?UTF-8?B?$subject_utf8_base64?=
				Content-Type: multipart/mixed; boundary="------------020509010905030507080406"
				
				This is a multi-part message in MIME format.
				--------------020509010905030507080406
				Content-Type: text/html; charset=utf-8
				Content-Transfer-Encoding: 8bit
				
				<html>
					<head>
						<meta http-equiv="content-type" content="text/html; charset=utf-8">
						<style type="text/css">
							body {
								background: #DED5BA;
							}
							.page {
								margin: 2em auto;
								width: 50em;
								background: #FFFFFF;
								overflow: auto;
							}
							.page .inner {
								margin: 2em;
							}
								.page .inner p {
								margin: 0.5em 0;
							}
						</style>
					</head>
					<body>
						<div class="page">
							<div class="inner">
								#evaluate ($content.template_name, $content)
							</div>
						</div>
					</body>
				</html>
				
				--------------020509010905030507080406
				Content-Type: text/xml; name="$attachment_file_name"
				Content-Transfer-Encoding: 8bit
				Content-Disposition: attachment; filename="$attachment_file_name"
				
				#evaluate ($pack.template_name, $pack)
				
				--------------020509010905030507080406--
			]"
-- 		not necessary if blank lines have leading tabs consistent with other lines
--			String.adjust_verbatim (Result)
		end

	Var_address: ASTRING
		once
			Result := "address"
		end

	Var_email_path: ASTRING
		once
			Result := "email_path"
		end

end
