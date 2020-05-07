# SWPP Compiler

This compiler converts LLVM IR to SWPP assembly.

NOTE: Please don't just fork this and use it as your team repository!
It will make your team repository public (visible to other teams).
Instead, create an empty private repository, copy the contents of
this repo to yours.

Whenever there is a change in this repo, you can cherry-pick the new commits.
Relevant links:
[here](https://coderwall.com/p/sgpksw/git-cherry-pick-from-another-repository),
[here](https://stackoverflow.com/questions/5120038/is-it-possible-to-cherry-pick-a-commit-from-another-git-repository).


Bug fixes:

- Apr. 30: Compilation error fix
- May. 1: Copy should emit bitwidth, SExt should correctly emit mask, PHI is incorrectly emitted when used by each other
- May. 3: Support global variables (SimpleBackend.cpp will lower them to `malloc` + `inttoptr <glb var address>`), switch should print dot at basic block names
- May. 7: Fix crash when a constant is given as a branch condition or an undef value is used, let global var allocation only happen at main

## How to compile

To compile this project, you'll need to clone & build LLVM 10.0 first.
Please follow README.md from https://github.com/aqjune/llvmscript using
llvm-10.0.json. If you did assignment 4 or 5, you will already have built this.

After LLVM 10.0 is successfully built, please run:

```
./configure.sh <LLVM bin dir (ex: ~/llvm-10.0-releaseassert/bin)>
make
```

To run tests including FileCheck and Google Test:

```
make test
```

## How to run

Compile LLVM IR `input.ll` into an assembly `a.s` using this command:

```
./sf-compiler input.ll -o a.s
```

To see the IR that has registers depromoted before emitting assembly, please run:

```
./sf-compiler input.ll -o a.s -print-depromoted-module
```
