# About

Efficient, and powerful text editor, with command programming language.

Ludwig is a text editor developed at the University of Adelaide. 
It is an interactive, screen-oriented text editor.
It may be used to create and modify computer programs, documents 
or any other text which consists only of printable characters.

Ludwig may also be used on hardcopy terminals or non-interactively, 
but it is primarily an interactive screen editor.

# Building

You will need to install Free Pascal Compiler (fpc) if you are building ludwig on linux.

```
make -f Makefile.linux NDEBUG=1 	(or .darwin)
```

This will produce `ludwig` which can be copied to your 
preferred directory for local binaries, eg `/usr/local/bin`. 

# Usage

Open/create a file with name <file-name>

```
ludwig <file-name>
```

The file `.ludwigrc` in your home directory will be loaded whenever you start ludwig. 
	
Or with some additional initialisation parameters

    ludwig -O -i <initialisation-file-name> <file-name>

        -O invokes Version 5 command names

        -i initialisation file (optional) executed after .ludwigrc
        
# Help

There are two help files

* old commands help files: "ludwighlp.idx"
* new commands help files: "ludwignewhlp.idx"

Copy these into /usr/local/help

```
mkdir -p /usr/local/help
cp *.idx /usr/local/help
```


A couple of useful commands (-O version) to get you started are:

```
km/home/<ac/
km/end/>eol [<ac] >ac/
```

This will make your home key move the cursor to the start of the line, and 
the end key move the cursor to the end of the current line. 

They can be put into an initialisation file or `.ludwigrc`

Quick notes, Ludwig command `\h` will give you the help pages on Ludwig commands 
and `\q` will exit the editing session.

