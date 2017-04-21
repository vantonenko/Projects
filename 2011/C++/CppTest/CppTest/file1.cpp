#include "stdafx.h"
#include "file1.h"
#include <iostream>

using namespace std;

int file1Var = 123;

Out out;

Out& sep_(Out& o) {
	return o << "__________________________________________";
}

Out& sept(Out& o) {
	return o << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
}

Out& sepp(Out& o) {
	return o << "++++++++++++++++++++++++++++++++++++++++++";
}

Out& sepd(Out& o) {
	return o << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
}

Out& seps(Out& o) {
	return o << "##########################################";
}

void print(const char* s) {
	cout << s << endl;
}

A operator+(const A& a, const A& b) {
	cout << "Operator A+A is invoked" << endl;
	return A();
}

// A operator+(const A&, const int&) {
// 	cout << "Operator A+i is invoked" << endl;
// 	return A();
// }

// A operator+(const int&, const A&) {
// 	cout << "Operator i+A is invoked" << endl;
// 	return A();
// }

B operator++(B& b) {
	cout << "++B" << endl;
	return B();
}

int A::qwerty = 456;

const int Class2::size2 = 100;

Simple Comp1::sts = 5;

//EA ea;
EB eb;

// Even though ~UnCopyable is pure virtual
// it should be defined
// it's conformance exception for destructors
UnCopyable::~UnCopyable() {};

namespace Test37 {
	void f1(Ca c1, Ca c2) {
		print("f1(Ca c1, Ca c2)");
	};
	void f1(Cb c1, Cb c2) {
		print("f1(Cb c1, Cb c2)");
	};
}

namespace Test38 {
	void f1(Ca &c1, Ca &c2) {
		print("f1(Ca &c1, Ca &c2)");
	};
	void f1(Cb &c1, Cb &c2) {
		print("f1(Cb &c1, Cb &c2)");
	};
}

namespace Test39 {
	void killer(C* c) {
		delete c;
		out << "killer";
	}
}

namespace Test41 {
	Base f(Base b) {
		return b;
	}
	Base& f1(Base& b) {
		return b;
	}
}

namespace Test42 {
	const Rational operator*(
		const Rational &a, const Rational &b) {
			// such realization is more efficient
			// than in operator+
			return Rational(a.numerator * b.numerator,
				a.denominator * b.denominator);
	}

	const Rational operator+(
		const Rational &a, const Rational &b) {
			// this is worse than in operator*
			Rational r(
				a.numerator * b.denominator + 
				b.numerator * a.denominator,
				a.denominator * b.denominator);
			return r;
	}

	ostream& operator<<(
		ostream &o, const Rational &r) {
		o << r.numerator << "/" << r.denominator;
		return o;
	}
}

namespace Test43 {
	ostream& operator<<(
		ostream& o, const Base &b) {
		for (int i = 0; i < b._size; i++) {
			o << b._m[i] << " ";
		}
		return o << endl;
	}
}

namespace Test44 {
	const int& Base::test01() const {
		return _val;
	}

	inline const int& Base::test02() const {
		return _val;
	}
}

namespace Test47 {
	void f(Base &b) {}
}

namespace Test51 {
}