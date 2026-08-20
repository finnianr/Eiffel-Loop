note
	description: "[
		Experimental class extending ${FILE_INFO} to detect reparse points on NTFS partitions using
		blacklisted `ntfs3' driver. Reparse points behave like symlinks.
		
		**WARNING**

		Use only in readonly mode with safe `mount' args:
		
			modprobe ntfs3
			mount -t ntfs3 /dev/<name> <path> -o ro,noatime,uid=$(id -u),gid=$(id -g)
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	date: "2026-08-18 12:00:00 GMT (Tuesday 18th August 2026)"
	revision: "1"

class
	EL_NTFS_FILE_INFO

inherit
	FILE_INFO

create
	make

feature -- Status report

	is_reparse_point: BOOLEAN
			-- Does the file carry `FILE_ATTRIBUTE_REPARSE_POINT',
			-- `FILE_ATTRIBUTE_RECALL_ON_OPEN', or
			-- `FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS', as reported by `ntfs3'
			-- through the `system.ntfs_attrib' extended attribute?
			-- Covers genuine reparse points (junctions, mount points, MSIX/UWP
			-- virtualization) as well as WOF-compressed and cloud-placeholder
			-- files, which are not reparse points in the strict sense but carry
			-- the same practical risk: reading them can trigger reparse
			-- processing or a network fetch.
			-- Always False on non-Linux platforms, on filesystems that do not
			-- expose this xattr (i.e. anything other than `ntfs3'/`ntfs-3g'), or
			-- if the lookup otherwise fails.
		require
			exists: exists
		do
			if attached internal_name_pointer as l_ptr then
				Result := c_is_reparse_point (l_ptr.item)
			end
		end

feature {NONE} -- Implementation

	c_is_reparse_point (a_path: POINTER): BOOLEAN
			-- Read the `system.ntfs_attrib' extended attribute for `a_path' and
			-- test for `FILE_ATTRIBUTE_REPARSE_POINT' (0x400),
			-- `FILE_ATTRIBUTE_RECALL_ON_OPEN' (0x40000), or
			-- `FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS' (0x400000).
			-- Uses `lgetxattr' rather than `getxattr' so a trailing symlink is not
			-- followed -- consistent with `is_symlink' already having handled the
			-- symlink case via `Precursor'.
		external
			"C inline use <sys/types.h>, <sys/xattr.h>, <string.h>"
		alias
			"{
				#ifdef __linux__
					unsigned int attrib = 0;
					ssize_t n;
					unsigned int mask;
					EIF_BOOLEAN result = EIF_FALSE;

					mask = 0x00000400u   /* FILE_ATTRIBUTE_REPARSE_POINT */
						| 0x00040000u		/* FILE_ATTRIBUTE_RECALL_ON_OPEN */
						| 0x00400000u;		/* FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS */

					n = lgetxattr ((const char *) $a_path, "system.ntfs_attrib", &attrib, sizeof (attrib));
					if (n == (ssize_t) sizeof (attrib) && (attrib & mask) != 0) result = EIF_TRUE;
				#endif
				return result;
			}"
		end

note
	notes: "[
		File information for NTFS filesystems mounted on Linux via the in-kernel
		`ntfs3' driver. `ntfs3' exposes NTFS reparse points -- junctions, volume
		mount points, and MSIX/UWP virtualization folders (e.g. under
		`WindowsApps') -- as plain `S_IFDIR' directories whenever the reparse tag
		is not one it knows how to translate into a symlink target, so the
		inherited `is_symlink' misses them. It also exposes WOF-compressed and
		cloud-placeholder files (`RECALL_ON_OPEN'/`RECALL_ON_DATA_ACCESS') as
		plain regular files, which carry a related but distinct risk: reading
		them can trigger reparse processing or, for cloud files, a network
		fetch -- both worth a walker skipping or treating specially.

		Detection here does NOT use `statx': despite some documentation
		suggesting otherwise, mainline Linux defines no
		`STATX_ATTR_REPARSE_POINT' flag in `stx_attributes' (confirmed against
		the `statx(2)' man page and kernel `uapi/linux/stat.h', which list only
		COMPRESSED, IMMUTABLE, APPEND, NODUMP, ENCRYPTED, AUTOMOUNT, MOUNT_ROOT,
		VERITY and DAX). Instead, `ntfs3' exposes the raw Windows
		`FILE_ATTRIBUTE_*' flags (from the inode's on-disk `$STANDARD_INFORMATION'
		attribute) through the `system.ntfs_attrib' extended attribute. This
		class reads that xattr via `lgetxattr' and tests for
		`FILE_ATTRIBUTE_REPARSE_POINT' (0x400), `FILE_ATTRIBUTE_RECALL_ON_OPEN'
		(0x40000), and `FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS' (0x400000).

		REQUIRES the in-kernel `ntfs3' driver. Confirmed empirically NOT to
		work under `ntfs-3g'/FUSE (`fuseblk'): `system.ntfs_attrib' is simply
		absent under `ntfs-3g' on this system (`getfattr -d -m .' returns
		nothing), so `is_reparse_point' silently returns False for everything.
		`ntfs-3g' also does not translate junctions/mount points to Unix
		symlinks the way `ntfs3' does, so the inherited `is_symlink' gains
		nothing either -- meaning this class provides NO additional detection
		capability over plain `FILE_INFO' when the target is mounted via
		`ntfs-3g'. Verify the mount type before relying on this class:
		`findmnt <path>' must report `FSTYPE ntfs3', not `fuseblk'.

		Byte order matters here and is easy to get wrong: `getfattr -e hex'
		prints the four raw on-disk bytes left-to-right as a hex dump, which is
		NOT the same as reading them as a little-endian `u32' -- e.g. on-disk
		bytes `20 00 04 00' print as `0x20000400' via `getfattr' but decode to
		the real attribute value `0x00040020' when read natively, as this C
		external does. Compare against `getfattr ... | od -An -tx1' (raw bytes)
		rather than `getfattr -e hex' (its own hex-dump ordering) if verifying
		a value by hand.
	]"

end
