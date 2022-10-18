# POPL'23 Artefact Documentation (#8)

## Installation

We provide a VM image of a Debian OS. The username and password are both "dargent" (without
the quotes). If root access is needed, the password is also "dargent".

Once logged in, we recommend reviewers to open a terminal. 
An `artefact` directory can be found in the home directory, which contains
the source code of the artefact. For the purpose of the artefact evaluation,
reviewers are not expected to need any other README files or documentations
included in the bundle. This file alone should suffice. 

In order to evaluate the artefact, the following programs are needed. They are already
_pre-installed_ so reviewers do not need to manually install anything.

* The GHC compiler (ghc)
* The Haskell Cabal (cabal)
* The Cogent compiler (cogent)
* Isabelle 2019 (isabelle)
* Python3 (python3)

We recommend reviewers to use this VM image for artefact evaluation, as the
dependencies are already configured and the setup has been tested. It is
possible to install dependencies and run the programs/proofs on reviewers' host
machines, but we do not see any major advantages of doing so. If reviewers have
to evaluate the artefact on local machines, the project
[repository](https://github.com/au-ts/cogent) has more instructions on how to
set up the environment, or please contact us for help. It should work on major
Linux distributions. MacOS also works but requires some extra headache. Please
note though, the artefact we provide in the VM for evaluation is not yet merged
to the project repository, so please don't use the project repository directly for
evaluation. The artefact is separately hosted on
[github](https://github.com/zilinc/popl23-artefact), which is identical to what
the VM contains.


## File Summary

We briefly summarise the directory structure below, so that reviewers are easier to navigate themselves.
Please proceed to the [List of Claims] section below for detailed evaluation steps.

Inside the `$HOME/artefact` directory, we have the following files and sub-directories. 

* `cogent/`: the Cogent compiler and verification framework, extended with Dargent.
    - `cogent/cogent/src/`: the Cogent compiler source code
    - `cogent/cogent/isa/`: Isabelle formalisation and proof about the language's semantics
    - `cogent/autocorres/`: our patched (see autocorres-patch.txt) version of the AutoCorres 1.6.1 library 
    - `cogent/c-refinementi/`: generic C refinement proofs
    - `cogent/cogent/tests/tests/dargent/`: more smaller Dargent test programs
* `autocorres-patch.txt`: the diff file showing the patch we have applied to the AutoCorres library
* `examples.cogent`: sample Cogent/Dargent code used in the paper's Section 2 and 3
* `power-control-system/`: Section 5.1
* `bitfields/`: Section 5.2
* `custom-encoding/`: Section 5.3
* `timer-driver-cogent/`: Section 6
* `sum-random/`: Section 6.4, L1043
* `arrays/`: Section 7, L1087


## How to Evaluate

* The Cogent compiler:

    It can be evaluated by inspecting the source code of the compiler, and compare them
    with the description in the paper. The compiler has already been installed in the VM,
    which will be used for compiling the examples presented in Section 5 and 6. If reviewers
    want to verify that the source code compiles, it can be done by the following steps:

    - `cd $HOME/artefact/cogent/cogent`
    - `cabal new-install --installdir=$HOME/.cabal/bin --overwrite-policy=always`

    But because the source code is identical to when it was last built, the `cabal new-install`
    command does not rebuild the compiler and it should report something like "Up to date".

* Isabelle formalisation and proof:

    Cogent is a certifying compiler and it produces a proof for every program it compiles.
    Parts of this proof are generic---they are independent of the
    specific program, for example the static semantics presented in Section 3.4.
    The static part of the Isabelle proof can be checked by running the following command:

    - `cd $HOME/artefact/cogent`
    - `L4V_ARCH="ARM" isabelle build -d c-refinement -d autocorres -d cogent/isa -b -v CogentCRefinement`

    We have already built the `CogentCRefinement` Isabelle image, which means, if the theorem
    files remain the same, the command above should finish in a few second without rebuilding
    the image. If the configuration or the source theorem files change, it may take more than
    10 minutes to rebuild. After running the above command, the output message should contain
    no errors. This image will be loaded by the proof of each compiled program.

    To check for unsoundness in the proofs, reviewers can grep "oops" and "sorry" in the Isabelle
    theorem files. Some `sorry`s are present in the generated `*_ShallowTuplesProof.thy` files.
    They are about the functional correctness of abstract Cogent functions, which we assume or
    axiomatise, as per this paper and the original Cogent paper [ICFP'16]. So these `sorry`s are
    irrelevant to the material that we present in the paper and do not compromise soundness.

* Example application implementations:

    For each application, reviewers can evaluate it by inspecting the source code, compiling
    the source code, and finally checking the Isabelle proof. Reviewers can also inspect the 
    generated C code, but it is hard to test them without the hardware and the underlying 
    seL4 operating system (the timer example in Section 6).

    We provide a Makefile for each application. Simply run `make` in each
    example's directory and it will compile the source code and generate all
    the needed C files and Isabelle theorem files. Then to check the proofs, please follow
    the detailed instructions in the [List of Claims] section below.


## List of Claims

(We assume file paths are relative to `$HOME/artefact` in this section, unless otherwise stated).

### Section 3: The Dargent Language

* The source code of the Cogent language is located in `cogent/cogent/src/`, and
  the Dargent specific files are in `cogent/cogent/src/Cogent/Dargent/`. Within 
  this directory, `Surface.hs` defines the surface language (Figure 3), `Core.hs`
  defines the core language (Figure 5). The desugarer (L491) is defined in
  `cogent/cogent/src/Cogent/Desugar.hs` (the `desugarLayout` function), together
  with the Cogent desugarer.

* For more Cogent programs that use Dargent, we have a testsuite located in
  `cogent/cogent/tests/tests/dargent/` and reviewers can look at the Dargent code.
  It can be batch-tested using a script:
  - Firstly, go to the directory `$HOME/artefact/cogent/cogent/tests/`
  - Then, run `./run-test-suite.py --include-dir=tests/dargent`
  It should report no fails or errors (but with a few WIPs). For each Cogent program, reviewers could inspect the code
  to get an intuition of the language's syntax, semantics, the compilation process and the
  results. This can be done using the following commands:
  - # Assume that the source Cogent program is called <SRC>
  - `cogent -t <SRC>`     # typechecks the program
  - `cogent -g -x <SRC>`  # generates C code and prints to stdout
  - `cogent -h`           # shows the help message
  - `cogent -h<LEVEL>`    # where <LEVEL> ranges from 0 to 4. Higher levels reveal a *lot* more commands and flags

* Section 3.4: The static semantics of Dargent. In the paper, our presentation is
  based on the Isabelle/HOL formalisation, which is less intricate than the compiler's
  implementation. To evaluate Section 3.4, we refer reviewers to the Isabelle file
  `cogent/cogent/isa/Cogent.thy`. 

  - L533: simplified types --> the `lrepr` type on line 520.
  - Figure 6: match rules --> the `match_repr_layout` definition on line 585.
  - Figure 7: well-formedness --> the `layout_wellformed` function on line 545.
  - Section 3.4.1: The record typing rule --> the `type_wellformed` function on line 688.
  - Section 3.4.2: Lemma 3.1 --> `lemma specialisation` on line 2952.


### Section 4: Dargent Verification

The proofs described in Section 4 of the paper are generated per program. In
order to evaluate the generated theorems, reviewers can compile an example
Cogent program from Section 5 of the paper and run Isabelle interactively to
see them. We use the power control program as an example. 

- Go to the directory `$HOME/artefact/power-control-system`.
- Run `./run.sh`.
  From the output message, we can see that the generated files are located in a
  `generated` directory. It loads all the proofs about the power control code.
  This is the command to be used when evaluating the proofs of the applications
  (see [Section 5-6: Applications] below). For the purpose of this section,
  reviewers do not need to wait until everything is processed. For most of the
  claims in Section 4, reviewers can inspect them in Isabelle by inserting a
  `thm <LemmaBucket>` command right before the last `end (* of locale *)` in
  the `*_CorresSetup.thy` file. These commands only print the lemma bucket,
  therefore we do not generate them in production code.

  We now list the claims and the corresponding name of the <LemmaBucket>.

  * The value relation for records with layouts (Section 4.1) --> `GetSetSimp`.
    The lemmas starting with `val_rel .. ≡ ..` in this bucket.

  * The direct definition of getters and setters (Section 4.1) --> `GetSetDefs`.
    The names of the direct getters and setters start with `deref_`. The correspondence with
    the AutoCorres embedded getters and setters --> `GetSetSimp`.

  * The refinement between record operations in C and Cogent (Section 4.2) --> `TakeBoxed`, `TakeUnboxed`,
    `PutBoxed`, `LetPutBoxed`, `PutUnboxed`, `MemberBoxed`, `MemberReadOnly`.

  * The compositional properties of custom getters and setters (Section 4.3) --> `GetSetSimp`.

  * The generated proofs that getters and setters comply with layouts (Section
    4.4) --> `GetSetSanity`.
    The lemmas that setters do not change any bit outside the
    field layout can be added to this bucket with the command `local_setup
    ‹local_setup_getset_sanity_lemmas "filename.c"›` (note the Unicode characters), as in
    `$HOME/artefact/timer-driver-cogent/verified_cogent_driver/DriverGetSet.thy`.


### Section 5-6: Applications

For each of the following example, please go to the relevant directory as listed below,
and run the `./run.sh` script. The script runs the Cogent compiler to generate C and/or
Isabelle files, and opens up an Isabelle session in jedit with the relevant theory files
loaded.

* The power control system (Section 5.1) can be found in
  `$HOME/artefact/power-control-system/`.
  Reviewers are expected to check in `generated/Pwr_AllRefine.thy` that
  the final refinement theorem is successfully proved.
  It may take half an hour for Isabelle to fully process the proof.

* The bit fields example (Section 5.2) can be found in
  `$HOME/artefact/bitfields/`.
  Reviewers are expected to check in `AllRefineAsmsSingleFile.thy` that
  the functional correctness of the function `foo` is successfully
  proved (lemma `corres_shallow_C_foo_concrete`).
  (ETA: 20mins)

* The custom encoding example (Section 5.3) can be found in
  `$HOME/artefact/custom-encoding/` and is evaluated by running
  `make`. This compiles the code to C and generates a bunch of theory files
  in the current directory. Open the file `Generated_AllRefine.thy` with
  Isabelle to check that the final refinement theorem is successfully proved.
  (ETA: 10mins)

* The timer device driver (Section 6) can be found in
  `$HOME/artefact/timer-driver-cogent/verified_cogent_driver/`.
  Reviewers are expected to check `DriverProof.thy`, which proves that the cogent driver
  satisfies its abstract specification (`concr_implementation` on line 114).
  (ETA: a few seconds)


### Section 6.4: Volatile

* The random seeds example (L1043 in the paper) summing two random numbers can
  be found in `$HOME/artefact/sum_random/`, and can be evaluated by running `./run.sh`.
  The generated file `./build/Random_seed_AllRefine.thy`
  produces a theorem stating that the generated C code of `sum` refines the
  shallow embedding of the Cogent `sum` function provided that the foreign
  antiquoted C code correctly refines `rand_with_seed`. The final
  `print_theorems` line in that file prints the generated theorem.

  The file `SeedRefinement.thy` contains a simple manual proof demonstrating
  how to prove that the shallow embedding of the Cogent code for
  `rand_with_seed` and for `sum` refine the set of all 64-bit numbers `UNIV`.
  Although this proof is trivial, it demonstrates how to abstract a function
  that takes a seed and returns a number and a seed to a set modelling non-determinism
  where the sum of two random numbers can be any number (not necessarily an
  even number). The refinement theorem for sum is called
  `sum_corres_monad_shallow`.
  (ETA: pretty quick)


### FFI proofs (L1088)

Existing proofs of a C word array library. It was used for demonstrating how to
compose Cogent and C proofs through Cogent's FFI with examples (a simple array
sum example and binary search). We adapted these proofs to work with the
Dargent extension.

* Sum of an array of integers can be found in `$HOME/artefact/arrays/sum-example`.
  To evaluate, run `./run.sh`. Reviewers are expected to check the file
  `Sum_AllRefine.thy`, which contains a theorem `sum_arr_C_correct` stating
  that the C code is correct. Namely that for a valid array, it succeeds,
  does not change the array, and any result of summing over array elements in
  C is equal to summing over an abstraction of the array to a list in
  Isabelle.
  (ETA: less than 10mins)

* The implementation of binary search is located in `$HOME/artefact/arrays/loops`.
  To evaluate, run `./run.sh`. Reviewers are expected to check the file
  `BinarySearch.thy`, which contains the final theorem `binary_search_C_correct` stating
  that the C code for binary search over a sorted array is correct. It means
  that, for a valid sorted array, it always succeeds, does not change the
  array, and if the value searched for is in the array returns the index at
  which it is found, otherwise, returns an index larger than the array length. 
  (ETA: less than 10mins)

