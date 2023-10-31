To re-create the `nnn` deb file, follow these steps:

1. Download the following files:
   - [nnn_4.9.orig.tar.gz](http://deb.debian.org/debian/pool/main/n/nnn/nnn_4.9.orig.tar.gz)
   - [nnn_4.9-1.debian.tar.xz](http://deb.debian.org/debian/pool/main/n/nnn/nnn_4.9-1.debian.tar.xz)

2. Extract the contents of both files.

3. Copy the `debian` folder from the extracted `nnn_4.9-1.debian.tar.xz` file into the `nnn-4.9` folder inside the `nnn_4.9.orig`.folder.

4. Add a new rule to the `rules` file inside the `debian` folder:

   ```makefile
   #!/usr/bin/make -f
   
   export DEB_BUILD_MAINT_OPTIONS = hardening=+all
   
   %:
   	dh $@
   
   override_dh_auto_install:
   
   override_dh_auto_build:
   	make -j8 "INSTALL=install --strip-program=true" O_NERD=1
   
   override_dh_missing:
   	dh_missing --fail-missing
   ```

5. Open the terminal and navigate to the `nnn-4.9` folder.

6. Run the command `dpkg-buildpackage -b` to build the `nnn` deb file in the parent folder.

