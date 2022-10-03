
# File summary

- cogent/ : the Cogent compiler and verification framework, extended with Dargent.

To build cogent, see cogent/docs/install.rst
 (e.g, cd cogent/cogent and then stack build)

- cogent/autocorres/ : our patched (see autocorres-patch.txt) version of the autocorres 1.6.1 library 

Examples of the paper are in the following directories.

- timer-driver-cogent/ (section 6)
- power-control-system/ (section 5.1)
- bitfields/ (section 5.2)
- custom-encoding/ (section 5.3)
- arrays/ (examples of L1087 in the paper)

For the convenience of reviewers, the generated files are also
included in the artefact so that they can be checked without installing
the cogent compiler. The final generated refinement proof is in `*_AllRefine.thy`

# Requirements

To parse the generated theory files, you need Isabelle 2019 with our version of AutoCorres 
(provided in cogent/autocorres).

Launch Isabelle with the following options:
`L4V_ARCH=ARM isabelle jedit -d /path/to/autocorres -l AutoCorres -d path/to/cogent`

For some examples, you also need python3.

# For MacOS users

If your `gcc` is the Apple clang compiler, you need to install GNU GCC (e.g.
via `brew install gcc`) and set the environment variables:
`CPP=/path/to/gnu/cpp` and `CC=/path/to/gnu/gcc` in the shell in which you
will be running cogent.

When running Isabelle, you may also need to add `declare [[cpp_path="/path/to/gnu/cpp"]]`
in the `*_ACInstall.thy` file before the `install_C_file` command.

Additionally, you may need to install GNU sed (it's called `gsed`) and use it instead of the default MacOS `sed`.
