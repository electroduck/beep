# Beep: Play a tone
This small assembly program provides a command-line interface for playing
tones on Windows PCs.  It can generate a tone at any frequency from 32 Hz to
32.767 kHz.  The compiled binary is only a few KB.

## Usage
`beep <frequency> <milliseconds>`
* `<frequency>` is the frequency of the tone (32-32767 Hz).
* `<milliseconds>` is the length of the tone in milliseconds.

The program will run in the background.  To wait for it to finish before
continuing, run `start /wait beep` instead of regular `beep`.

## Building
The `build.bat` file builds the EXE using NASM and GoLink, both of which must
be in the PATH.  Building with other tools is simple: assemble the two .asm
files and link them with Kernel32 and User32 into an EXE file.

## System Requirements (READ THIS)
This program is based on the WinAPI function `Beep` in Kernel32.  **It does
not work on Windows XP 64-bit or Windows Vista.**  On Windows XP and prior
versions, it will play the tone directly from the internal motherboard speaker,
which may or may not exist.  On Windows 7 and later versions, it will play the
tone through the sound card.
