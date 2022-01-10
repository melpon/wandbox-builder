// Lazy K interpreter in C++.
// For usage see usage() function below.
// Copyright 2002 Ben Rudiak-Gould. Distributed under the GPL.
//
// Implementation notes:
//  - When Sxyz is reduced to (xz)(yz), both "copies" of z
//    point to the same expression tree. When z (or any of
//    its subexpressions) is reduced, the old tree nodes are
//    overwritten with their newly reduced versions, so that
//    any other pointers to the node get the benefit of the
//    change. This is critical to the performance of any
//    lazy evaluator. Despite this destructive update, the
//    meaning (i.e. behavior) of the function described by
//    any subtree never changes (until the nodes are
//    garbage-collected and reassigned, that is).
//  - I actually got stack overflows in the evaluator when
//    running complicated programs (e.g. prime_numbers.unl
//    inside the Unlambda interpreter), so I rewrote it to
//    eliminate recursion from partial_eval() and free().
//    These functions now use relatively abstruse iterative
//    algorithms which borrow expression tree pointers for
//    temporary storage, and restore the original values
//    where necessary before returning. Other than that, the
//    interpreter is pretty simple to understand. The only
//    recursion left (I think) is in the parser and in the
//    Inc case of partial_eval_primitive_application; the
//    former will only bite you if you have really deep
//    nesting in your source code, and the latter only if
//    you return a ridiculously large number in the output
//    stream.
//


#include <stdio.h>
//#include <io.h>
#include <fcntl.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/types.h>


class Expr {
private:
	int refcnt;
	union {
		Expr* arg1;
		int numeric_arg1;
	};
	Expr* arg2;

	static Expr* free_list;
	static Expr* alloc();
	void free();

	void partial_eval_primitive_application();

public:
	enum Type { A, K, K1, S, S1, S2, I1, LazyRead, Inc, Num, Free } type;

	static void* operator new(size_t) {
		Expr* result = free_list;
		if (result) {
			free_list = result->arg1;
			return result;
		} else {
			return alloc();
		}
	}

	// caller keeps original ref plus returned ref
	Expr* dup() {
		++refcnt;
		return this;
	}
	// caller loses original ref
	void deref() {
		if (--refcnt == 0) {
			free();
		}
	}

	// caller keeps original ref
	Type gettype() { return type; }

	// caller loses refs to a1 and a2, gets ref to new object
	Expr(Type t, Expr* a1 =0, Expr* a2 =0) {
		refcnt = 1;
		type = t;
		arg1 = a1; arg2 = a2;
	}

	// caller loses original ref, gets returned ref
	Expr* partial_eval();

	// caller loses original ref, gets returned ref
	static Expr* partial_apply(Expr* lhs, Expr* rhs) {
		// You could do something more complicated here,
		// but I tried it and it didn't seem to improve
		// execution speed.
		return new Expr(A, lhs, rhs);
	}

	// caller loses original ref
	int to_number() {
		int result = (type == Num) ? numeric_arg1 : -1;
		deref();
		return result;
	}
#if 0
	void print(Expr*);
#endif
	// caller loses original ref, gets returned ref
	Expr* drop_i1() {
		Expr* cur = this;
		if (type == I1) {
			do {
				cur = cur->arg1;
			} while (cur->type == I1);
			cur = cur->dup();
			this->deref();
		}
		return cur;
	}
};


Expr* Expr::free_list = 0;


Expr K(Expr::K);
Expr S(Expr::S);
Expr I(Expr::S2, &K, &K);
Expr KI(Expr::K1, &I);

Expr SI(Expr::S1, &I);
Expr KS(Expr::K1, &S);
Expr KK(Expr::K1, &K);
Expr SKSK(Expr::S2, &KS, &K);
Expr SIKS(Expr::S2, &I, &KS);
Expr Iota(Expr::S2, &SIKS, &KK);

Expr Inc(Expr::Inc);
Expr Zero(Expr::Num);


Expr* Expr::alloc() {
	enum { blocksize = 10000 };
	static Expr* p = 0;
	static Expr* end = 0;
	if (p >= end) {
		p = (Expr*)malloc(blocksize*sizeof(Expr));
		if (p == 0) {
			fputs("Out of memory!\n", stderr);
			exit(2);
		}
		end = p + blocksize;
	}
	return p++;
}

#if 0
void Expr::print(Expr* highlight) {
	if (this == highlight) {
		fputs("###", stdout);
	}
	switch (type) {
		case A:
			putchar('(');
			arg1->print(highlight);
			putchar(' ');
			arg2->print(highlight);
			putchar(')');
			break;
		case K:
			putchar('K');
			break;
		case K1:
			fputs("[K ", stdout);
			arg1->print(highlight);
			putchar(']');
			break;
		case S:
			putchar('S');
			break;
		case S1:
			fputs("[s ", stdout);
			arg1->print(highlight);
			putchar(']');
			break;
		case S2:
			fputs("[S ", stdout);
			arg1->print(highlight);
			putchar(' ');
			arg2->print(highlight);
			putchar(']');
			break;
		case I1:
			putchar('.');
			arg1->print(highlight);
			break;
		case LazyRead:
			fputs("LazyRead", stdout);
			break;
		case Inc:
			fputs("Inc", stdout);
			break;
		case Num:
			printf("%d", numeric_arg1);
			break;
		default:
			putchar('?');
	}
	if (this == highlight) {
		fputs("###", stdout);
	}
}
#endif

Expr* make_church_char(int ch) {
	if (ch < 0 || ch > 256) {
		ch = 256;
	}

	static Expr* cached_church_chars[257] = { KI.dup(), I.dup() };

	if (cached_church_chars[ch] == 0) {
		cached_church_chars[ch] = new Expr(Expr::S2, SKSK.dup(), make_church_char(ch-1));
	}
	return cached_church_chars[ch]->dup();
}


Expr* g_expr;


// This function modifies the object in-place so that
// all references to it see the new version.

void Expr::partial_eval_primitive_application() {
	Expr* lhs = arg1;
	Expr* rhs = arg2->drop_i1();

	// arg1 and arg2 are now uninitialized space

	switch (lhs->type) {
	case K:
		type = K1;
		arg1 = rhs;
		arg2 = 0;
		break;
	case K1:
		type = I1;
		arg1 = lhs->arg1->dup();
		arg2 = 0;
		rhs->deref();
		break;
	case S:
		type = S1;
		arg1 = rhs;
		arg2 = 0;
		break;
	case S1:
		type = S2;
		arg1 = lhs->arg1->dup();
		arg2 = rhs;
		break;
	case LazyRead:
		lhs->type = S2;
		lhs->arg1 = new Expr(S2, I.dup(), new Expr(K1, make_church_char(getchar())));
		lhs->arg2 = new Expr(K1, new Expr(LazyRead));
		// fall thru
	case S2:
		//type = A;
		arg1 = partial_apply(lhs->arg1->dup(), rhs->dup());
		arg2 = partial_apply(lhs->arg2->dup(), rhs);
		break;
	case Inc:
		rhs = rhs->partial_eval();
		type = Num;
		numeric_arg1 = rhs->to_number() + 1;
		if (numeric_arg1 == 0) {
			fputs("Runtime error: invalid output format (attempted to apply inc to a non-number)\n", stderr);
			exit(3);
		}
		arg2 = 0;
		break;
	case Num:
		fputs("Runtime error: invalid output format (attempted to apply a number)\n", stderr);
		exit(3);
	default:
		fprintf(stderr, "INTERNAL ERROR: invalid type in partial_eval_primitive_application (%d)\n", lhs->type);
		exit(4);
	}
	lhs->deref();
}


Expr* Expr::partial_eval() {
	Expr* prev = 0;
	Expr* cur = this;
	for (;;) {
		cur = cur->drop_i1();
		while (cur->type == A) {
			Expr* next = cur->arg1->drop_i1();
			cur->arg1 = prev;
			prev = cur; cur = next;
		}
		if (!prev) {
			return cur;
		}
		Expr* next = cur; cur = prev;
		prev = cur->arg1;
		cur->arg1 = next;
		cur->partial_eval_primitive_application();
	}
}


/*
void Expr::free() {
	if (type != Num) {
		if (arg1) arg1->deref();
		if (arg2) arg2->deref();
	}
	type = Free;
	arg1 = free_list;
	free_list = this;
}
*/

void Expr::free() {
	Expr* cur = this;
	Expr* partially_free_list = 0;
	for (;;) {
		while (--cur->refcnt <= 0 && cur->arg1 != 0 && cur->type != Num) {
			Expr* next = cur->arg1;
			if (cur->arg2 != 0) {
				cur->arg1 = partially_free_list;
				partially_free_list = cur;
			} else {
				cur->arg1 = free_list;
				free_list = cur;
			}
			cur = next;
		}
		if (partially_free_list == 0) {
			break;
		}
		cur = partially_free_list;
		partially_free_list = partially_free_list->arg1;
		cur->arg1 = free_list;
		free_list = cur;
		cur = cur->arg2;
	}
}


class Stream {
public:
	virtual int getch() = 0;
	virtual void ungetch(int ch) = 0;
	virtual void error(const char* msg) = 0;
};

class File : public Stream {
	FILE* f;
	const char* filename;
	enum { circular_buf_size = 256 };
	char circular_buf[circular_buf_size];
	int last_newline, cur_pos;
public:
	File(FILE* _f, const char* _filename) {
		f = _f; filename = _filename;
		last_newline = cur_pos = 0;
	}
	int getch();
	void ungetch(int ch);
	void error(const char* msg);
};

int File::getch() {
	int ch;
	do {
		ch = getc(f);
		circular_buf[(cur_pos++)%circular_buf_size] = ch;
		if (ch == '#') {
			do {
				ch = getc(f);
			} while (ch != '\n' && ch != EOF);
		}
		if (ch == '\n') {
			last_newline = cur_pos;
		}
	} while (isspace(ch));
	return ch;
}

void File::ungetch(int ch) {
	ungetc(ch, f);
	--cur_pos;
}

void File::error(const char* msg) {
	fprintf(stderr, "While parsing \"%s\": %s\n", filename, msg);
	int from;
	if (cur_pos-last_newline < circular_buf_size) {
		from = last_newline;
	} else {
		from = cur_pos-circular_buf_size+1;
		fputs("...", stdout);
	}
	for (int i=from; i < cur_pos; ++i) {
		putc(circular_buf[i%circular_buf_size], stderr);
	}
	fputs(" <--\n", stderr);
	exit(1);
}

class StringStream : public Stream {
	const char* str;
	const char* p;
public:
	StringStream(const char* s) {
		str = s; p = s;
	}
	int getch() {
		return *p ? *p++ : EOF;
	}
	void ungetch(int ch) {
		if (ch != EOF) --p;
	}
	void error(const char* msg) {
		fprintf(stderr, "While parsing command line: %s\n%s\n", msg, str);
		for (const char* q = str+1; q < p; ++q) {
			putc(' ', stderr);
		}
		fputs("^\n", stderr);
		exit(1);
	}
};


Expr* parse_expr(Stream* f, int ch, bool i_is_iota);

Expr* parse_manual_close(Stream* f, int expected_terminator);


Expr* parse_expr(Stream* f, int ch, bool i_is_iota) {
	switch (ch) {
	case '`': case '*':
	{
		Expr* p = parse_expr(f, f->getch(), ch=='*');
		Expr* q = parse_expr(f, f->getch(), ch=='*');
		return Expr::partial_apply(p, q);
	}
	case '(':
		return parse_manual_close(f, ')');
	case ')':
		f->error("Mismatched close-parenthesis!");
	case 'k': case 'K':
		return K.dup();
	case 's': case 'S':
		return S.dup();
	case 'i':
		if (i_is_iota)
			return Iota.dup();
		// else fall thru
	case 'I':
		return I.dup();
	case '0': case '1':
	{
		Expr* e = I.dup();
		do {
			if (ch == '0') {
				e = Expr::partial_apply(Expr::partial_apply(e, S.dup()), K.dup());
			} else {
				e = Expr::partial_apply(S.dup(), Expr::partial_apply(K.dup(), e));
			}
			ch = f->getch();
		} while (ch == '0' || ch == '1');
		f->ungetch(ch);
		return e;
	}
	default:
		f->error("Invalid character!");
	}
	return 0;
}


Expr* parse_manual_close(Stream* f, int expected_terminator) {
	Expr* e = 0;
	int peek;
	while (peek = f->getch(), peek != ')' && peek != EOF) {
		Expr* e2 = parse_expr(f, peek, false);
		e = e ? Expr::partial_apply(e, e2) : e2;
	}
	if (peek != expected_terminator) {
		f->error(peek == EOF ? "Premature end of program!" : "Unmatched trailing close-parenthesis!");
	}
	if (e == 0) {
		e = I.dup();
	}
	return e;
}


static Expr* car(Expr* list) {
	return Expr::partial_apply(list, K.dup());
}

static Expr* cdr(Expr* list) {
	return Expr::partial_apply(list, KI.dup());
}

static int church2int(Expr* church) {
	Expr* e = Expr::partial_apply(Expr::partial_apply(church, Inc.dup()), Zero.dup());
	g_expr = e;
	int result = e->partial_eval()->to_number();
	if (result == -1) {
		fputs("Runtime error: invalid output format (result was not a number)\n", stderr);
		exit(3);
	}
	return result;
}


Expr* compose(Expr* f, Expr* g) {
	return new Expr(Expr::S2, new Expr(Expr::K1, f), g);
}


Expr* append_program(Expr* old, Stream* stream) {
	return compose(parse_manual_close(stream, EOF), old);
}


void usage() {
	fputs(
		"usage: lazy [-b] { -e program | program-file.lazy } *\n"
		"\n"
		"   -b           puts stdin and stdout into binary mode on systems that care\n"
		"                (i.e. Windows)\n"
		"\n"
		"   -e program   takes program code from the command line (like Perl's -e\n"
		"                switch)\n"
		"\n"
		"   program-file.lazy   name of file containing program code\n"
		"\n"
		" If more than one -e or filename argument is given, the programs will be\n"
		" combined by functional composition (but in Unix pipe order, not mathematical-\n"
		" notation order). If no -e or filename argument is given, the result is a\n"
		" degenerate composition, i.e. the identity function.\n", stdout);
	exit(0);
}


int main(int argc, char** argv) {
	Expr* e = I.dup();
	for (int i=1; i<argc; ++i) {
		if (argv[i][0] == '-') {
			switch (argv[i][1]) {
			case 0: {
				File f = File(stdin, "(standard input)");
				e = append_program(e, &f);
				break;
			}
			case 'b':
				//setmode(fileno(stdin), O_BINARY);
				//setmode(fileno(stdout), O_BINARY);
				break;
			case 'e': {
				++i;
				if (i == argc) {
					usage();
				}
				StringStream f = StringStream(argv[i]);
				e = append_program(e,&f);
				break;
			}
			default:
				usage();
			}
		} else {
			FILE* f = fopen(argv[i], "r");
			if (!f) {
				fprintf(stderr, "Unable to open the file \"%s\".\n", argv[i]);
				exit(1);
			}
			File f2 = File(f, argv[i]);
			e = append_program(e, &f2);
		}
	}
	e = Expr::partial_apply(e, new Expr(Expr::LazyRead));
	for (;;) {
		int ch = church2int(car(e->dup()));
		if (ch >= 256)
			return ch-256;
		putchar(ch);
		e = cdr(e);
	}
}
