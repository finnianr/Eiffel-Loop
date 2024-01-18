note
	description: "[
		[https://utho.com/docs/tutorial/most-common-network-port-numbers-for-linux/
		Most common default network port numbers for Linux]. Accessible via class ${EL_SHARED_SERVICE_PORT}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 8:58:07 GMT (Monday 30th October 2023)"
	revision: "3"

class
	EL_SERVICE_PORT_ENUM

inherit
	EL_ENUMERATION_NATURAL_16
		rename
			foreign_naming as Snake_case_upper
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			DNS := 53
			FTP := 21
			FTP_data := 20
			HTTP := 80
			IMAP := 143
			IPP := 631
			NetBIOS := 137
			POP3 := 110
			SMB := 445
			SMTP := 25
			SNMP_1 := 161
			SNMP_2 := 162
			Telnet := 23

		-- Secure ports
			HTTPS := 443
			IMAPS := 993
			POP3S := 995
			SMTPS := 465
			SSH := 22

		-- UDP
			NTP := 123
			UDP_server := 67
			UDP_client := 68
			
			create secure_table.make (<<
				[HTTP, HTTPS], [IMAP, IMAPS], [POP3, POP3S], [SMTP, SMTPS]
			>>)
		end

feature -- Access

	related (port: NATURAL_16): ARRAY [NATURAL_16]
		-- array of `port' + related secure version if it exists
		do
			if secure_table.has_key (port) then
				Result := << port, secure_table.found_item >>

			else
				Result := << port >>
			end
		end

	secure_table: EL_HASH_TABLE [NATURAL_16, NATURAL_16]
		-- lookup secure version of port

feature -- TCP ports

	DNS: NATURAL_16
		-- (Domain Name Service)
		-- Responsible for resolving a domain name to machine-readable IP addresses.

	FTP: NATURAL_16
		-- (File Transfer Protocol)
		-- For establishing a connection between two hosts. It's referred to as the command or control port.

	FTP_data: NATURAL_16
		-- (File Transfer Protocol) port for data transfer between client and server.

	HTTP: NATURAL_16
		-- (Hyper Text Transfer Protocol) is used for unsecured web traffic.

	IMAP: NATURAL_16
		-- (Internet Messaging Application Protocol) Manages electronic mail messages
		-- on the mail server. Does not provide encryption.

	IPP: NATURAL_16
		--	Internet Printing Protocol.	

	NetBIOS: NATURAL_16
		-- protocol used for File and Print Sharing.

	POP3: NATURAL_16
		-- (Post Office Protocol). Protocol for unencrypted access to a mail server.

	SMB: NATURAL_16
		-- (Server Message Block) Port. Used for file sharing.

	SMTP: NATURAL_16
		-- (Simple Mail Transfer Protocol). A protocol used by mail servers to send and receive mail.

	SNMP_1: NATURAL_16
		-- protocol is used for sending commands and messages.

	SNMP_2: NATURAL_16
		-- protocol is used for sending commands and messages.

	Telnet: NATURAL_16
		-- . This is a remote login service that is unencrypted.
		-- Data is sent in plain text and is hence considered insecure. It was deprecated in favor of SSH.

feature -- Secure TCP ports

	HTTPS: NATURAL_16
		-- (Hyper Text Transfer Protocol Secure) is used for encrypted web traffic.
	IMAPS: NATURAL_16
		-- (Internet Messaging Application Protocol Secure) Secure protocol for IMAP
		-- and provides SSL/TLS encryption.

	POP3S: NATURAL_16
		-- (Post Office Protocol Secure). Provides encryption for POP3 protocol.

	SMTPS: NATURAL_16
		-- (Simple Mail Transfer Protocol Secure). Provides encryption for the SMTP Protocol.

	SSH: NATURAL_16
		--(Secure Shell) port. This is a secure remote login service where data is encrypted.

feature -- UDP ports

	NTP: NATURAL_16
		-- (UDP Network Time Protocol).

	UDP_client: NATURAL_16
		-- Used by a DHCP client.

	UDP_server: NATURAL_16
		-- Used by the DHCP server (Dynamic Host Configuration Protocol).

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end