
.PHONY: all load-all-libs_lisp

all:	y-add-me

y-add-me:	z-ALL_LIBS makefile
	@cat z-ALL_LIBS > y-add-me
	@make -s load-all-libs_lisp >> y-add-me

z-ALL_LIBS:	x-all-libs makefile
	sed -e '1s/^/ARG ALL_LIBS="/' \
	    -e 's/$$/ \\/' \
	    -e '$$s/ \\$$/"/' \
	  < x-all-libs \
	  > z-ALL_LIBS

load-all-libs_lisp:	makefile
	echo "RUN ( echo '(progn ' \
	    ; for f in \$${ALL_LIBS} ; do \
	        echo '  (cl:handler-case (ql:quickload :\$$f) (cl:error (c) (declare (ignore c))))' \
	    ; done \
	    ; echo ')' \
	  ) > load-all-libs.lisp"
