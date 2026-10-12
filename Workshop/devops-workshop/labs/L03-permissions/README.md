# L03: File Permissions Lab

| | |
|---|---|
| **Duration** | 15 minutes |
| **Learning objective** | Read basic Linux file permissions and use `chmod` to control access. |
| **Lab task** | Make a script runnable and protect a private file. |

## What you will learn

Linux permissions decide who can read, change, or run a file:

- **Owner**: the user who owns the file
- **Group**: users in the file’s group
- **Others**: everyone else

Permission letters:

| Letter | Meaning |
|---|---|
| `r` | Read |
| `w` | Write or change |
| `x` | Execute a file or enter a directory |
| `-` | Permission is not granted |

For example, `-rw-r--r--` means the owner can read and write, while the group and others can only read.

## Prerequisites

- A Linux terminal, such as a lab VM, Codespace, or WSL.
- Bash available in the terminal.

## Step 1: Create the practice files

From the directory containing this lab, run:

```bash
bash setup.sh
cd ~/labs/L03-simple
```

The setup script creates a small practice directory in your home folder.

## Step 2: Inspect the permissions

```bash
ls -l
```

Find `hello.sh` and `private.txt`. Notice that `hello.sh` does not have execute permission.

## Step 3: Make the script runnable

Try running the script:

```bash
./hello.sh
```

It should fail with a permission error. Give the owner execute permission:

```bash
chmod u+x hello.sh
```

Run it again:

```bash
./hello.sh
```

You should see:

```text
Hello from the permissions lab!
```

## Step 4: Protect the private file

Check the current permissions:

```bash
ls -l private.txt
```

Set the file so only its owner can read and write it:

```bash
chmod 600 private.txt
```

Check the result:

```bash
ls -l private.txt
```

The permission string should be `-rw-------`.

## Step 5: Review

Answer these questions:

1. What does `x` allow you to do with a script?
2. What does `chmod u+x hello.sh` change?
3. Who can read `private.txt` after `chmod 600 private.txt`?

## Reset the lab

To recreate the practice files, run the setup script again from the directory where it is saved:

```bash
bash setup.sh
```

## Safety note

Practice only in the lab directory. Avoid using `chmod 777`; it gives every user permission to read, change, and execute a file.