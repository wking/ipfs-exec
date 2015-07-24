Usage
-----

    ipfs-exec.sh [options] IPFS_PATH COMMAND…

Options:

* `--help`  print the help and exit
* `--output PATH`  set the output directory
* `--version`  print the version number and exit

Description
-----------

Pull content from [IPFS][], enter the resulting directory, and run
`COMMAND…`.

The possibilities are endless, but one useful task is pulling an [Open
Container Initiative][OCI] [container][specs] from IPFS and launching
it with [runC][].

    $ ipfs-exec.sh --output ipfs-gateway QmTWEdJXBLEFytYv8cSEiC7z2NLPkPxNVNvcAPJYxJKEAQ make

Dependencies
------------

* A [POSIX shell][POSIX]
* An [`ipfs` command][ipfs]

[IPFS]: http://ipfs.io/
[OCI]: https://www.opencontainers.org/
[specs]: https://github.com/opencontainers/specs
[runC]: https://github.com/opencontainers/runc
[POSIX]: http://pubs.opengroup.org/onlinepubs/9699919799/
[ipfs]: http://ipfs.io/docs/install/
