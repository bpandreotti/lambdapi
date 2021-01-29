Lambdapi, a proof assistant based on the λΠ-calculus modulo rewriting [![Gitter][gitter-badge]][gitter-link] [![Matrix][matrix-badge]][matrix-link]
=====================================================================

Lambdapi is a proof assistant based on the λΠ-calculus modulo
rewriting. It comes with Emacs and VSCode extensions. More details
are given in the [User Manual](https://lambdapi.readthedocs.io).
Lambdapi files must end with `.lp`. Lambdapi can also read
[Dedukti](https://deducteam.github.io/) files (extension `.dk`) and
convert them to Lambdapi files.

Operating systems
-----------------

Lambdapi requires a Unix-like system. It should work on Linux as well as on
MacOS. It might be possible to make it work on Windows too with Cygwin or
"bash on Windows".

Installation via [Opam](http://opam.ocaml.org/)
---------------------

Lambdapi is under active development. A new version of the `lambdapi`
Opam package will be released soon, when the development will have reached a
more stable point. For now, we advise you to pin the development
repository to get the latest development version.
```bash
opam pin add lambdapi https://github.com/Deducteam/lambdapi.git
opam install lambdapi # install emacs and vim support as well
```
For installing the VSCode extension, you need to get the sources (see below).

Compilation from the sources
----------------------------

You can get the sources using `git` as follows:
```bash
git clone https://github.com/Deducteam/lambdapi.git
```

Dependencies are described in `lambdapi.opam`. For tests, one also
needs [alcotest](https://github.com/mirage/alcotest) and
[alt-ergo](https://alt-ergo.ocamlpro.com/). For building the
source code documentation, one needs
[odoc](https://github.com/ocaml/odoc).

**Note on the use of Why3:** the command `why3 config --full-config`
must be run to update the Why3 configuration when a new prover is
installed (including on the first installation of Why3).

Using Opam, a suitable OCaml environment can be setup as follows.
```bash
opam switch 4.11.1
opam install dune bindlib timed menhir pratter yojson cmdliner why3 alcotest alt-ergo odoc
why3 config --full-config
```

To compile Lambdapi, just run the command `make` in the source directory.
This produces the `_build/install/default/bin/lambdapi` binary.
Use the `--help` option for more information. Other make targets are:

```bash
make                        # Build lambdapi
make doc                    # Build the source code documentation
make install                # Install lambdapi
make install_emacs          # Install emacs mode
make install_vim            # Install vim support
make -C editors/vscode make # Install vscode extension
```

**Note:** you can run `lambdapi` without installing it with `dune exec -- lambdapi`.

The following commands can be used for cleaning up the repository:
```bash
make clean     # Removes files generated by OCaml.
make distclean # Same as clean, but also removes library checking files.
make fullclean # Same as distclean, but also removes downloaded libraries.
```

[gitter-badge]: https://badges.gitter.im/Deducteam/lambdapi.svg
[gitter-link]: https://gitter.im/Deducteam/lambdapi
[matrix-badge]: http://strk.kbt.io/tmp/matrix_badge.svg
[matrix-link]: https://riot.im/app/#/room/#lambdapi:matrix.org
