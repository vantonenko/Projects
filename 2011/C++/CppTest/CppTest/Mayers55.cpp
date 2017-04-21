#include "stdafx.h"
#include <iostream>
#include "file1.h"
#include <vector>
#include <list>
#include <deque>
#include <set>
#include <map>
#include <iterator>
#include <conio.h>
#include <algorithm>
#include <numeric> // for accumulate algorithm
#include <math.h>
#include <functional>

using namespace std;

void mtest1() {
	Class1 a;
	Class1 b(1);
	Class1 c(1, 2);

	//b = 1; // can't do this according to explicit attribute

	Class2 d;

	// constructor Class2(1, default) is invoked, 
	// after that tmp object is copied to d
	d = 1;
}

void mtest2() {
	auto x = 5; // C++0x

	cout << typeid(x).name() << endl;

	vector<int> vect;

	for (int i = 0; i < 10; i++) {
		vect.push_back(i);
	}

	for (auto iter = vect.begin(); iter != vect.end(); iter++) {
		cout << *iter << endl;
	}
}

void mtest3() {
	Class2 c;

	c[2] = '!';

	const Class2 &cc = c;

	//cc.fnconst(); // illegal, fnconst function doesn't have const attribute
	cc.fconst();

	cout << cc[2] << endl;

	// cc[2] = '@'; // illegal, const version of operator[] returns const char
}

void mtest4() {
	const Class3 cc;

	cout << cc[1] << endl;

	Class3 c;

	cout << c[1] << endl;

	c[1] = '#';
	// next is illegal, const version of 
	// operator[] returns const char&
	//cc[1] = '$';
}

void mtest5() {
	Comp0 c0;

	cout << "_________" << endl;

	Comp1 c1;
}

void mtest6() {
	// legal, because compiler generates 
	// default public constructor
	Class4 c4;

	c4;

	// illegal, Class5 has one constructor 
	// with parameters, so compiler doesn't 
	// generate default constructor
	//Class5 c5;

	vector<int>vect(1000); // space is not necessary
}

void mtest7() {
	int i = 5;

	RC rc(i);

	rc.f();

	i = 6;

	rc.f();

	// illegal, constructor RC needs reference
	// but not value
	//RC rc1 = 7;

	RC rc2(rc); // now rc2 refers to the same int object - i

	i = 7;

	rc2.f();

	int j = 1;

	RC rc3(j);

	// illegal, there is no default defined
	// operator= for RC
	// compiler doesn't know what should it do
	// with "int& i" field
	// because reference can't be reassigned 
	// to another object
	// btw: same situation is being going
	// when class has const field.
	// So user must define operator= in such cases.
	//rc3 = rc2;
}

void mtest8() {
	// illegal, can't access to destructor
	//Class6 c6;

	NonCopy1 nc11;

	// gives unresolved external symbol 
	// NonCopy1(const NonCopy1&)
	// It's one of the way to forbid copy constructor
	// just declare it but don't define
	//NonCopy1 nc12(nc11);

	NonCopy1 nc13;

	// gives unresolved external symbol error
	//nc13 = nc11;

	NonCopy2 nc21;

	// gives compile error: can not access 
	// private copy constructor
	// This way is more preferable because
	// error is got while compile time but 
	// not while linking time
	//NonCopy2 nc22(nc21);

	NonCopy2 nc23;

	// gives compile error
	//nc23 = nc21;

	NonCopy3 nc31, nc32;

	// gives compile error
	//nc31 = nc32;
}

void test35() {
	using namespace Test35;

	Derived d;

	Derived *pd = &d;

	// outputs "f(): class Derived"
	// Even though f() is member of Base
	// according to polymorphic of Base class
	pd->f();
}

void test36() {
	using namespace Test36;

	Base b(1000), b1(10000000);

	cout << b[800] << endl;

	b = b;

	cout << b[800] << endl;

	b1 = b;

	cout << b1[800] << endl;

	Base c(b1);

	cout << c[800] << endl;
}

void test37() {
	using namespace Test37;

	Ca a;
	Cb b;

	f1(a, a); // Ca, Ca

	f1(b, b); // Cb, Cb

	f1(b, a); // Ca, Ca

	f1(a, b); // Ca, Ca
	// You can see polymorphic class & references in 38
}

void test38() {
	using namespace Test38;

	// use polymorphic class & references
	Ca a;
	Cb b;

	// gives the same result as in 37
	f1(a, a); // Ca, Ca

	f1(b, b); // Cb, Cb

	f1(b, a); // Ca, Ca

	f1(a, b); // Ca, Ca
}

void test39() {
	using namespace Test39;

	auto_ptr<int> pi(new int);
	//auto_ptr<int> pi1 = (new int); // illegal

	auto_ptr<C> pc(new C);

	pc->name();

	auto_ptr<C> pc1(pc);

	pc1->name();

	// this gives crash(assert) because pc was derefered
	// while auto_ptr<C> pc1(pc);
	//pc->name();

	print("__________________");

	shared_ptr<C> spc(new C);

	spc->name();

	// now two shared_ptr<C> objects refers
	// to same C object
	shared_ptr<C> spc1(spc);

	spc1->name();
	spc->name(); //!!! spc was not derefered

	out << "~~~~~~~~~~~~~~~~~~~~~~" << "#####";

	{
		// functor
		shared_ptr<C> spc2(new C, Killer());

		// pointer to function
		shared_ptr<C> spc3(new C, killer);

		// without deleter
		shared_ptr<C> spc4(new C);

		// pointer to static member-function
		shared_ptr<C> spc5(new C, Killer::kill);

		shared_ptr<C> spc6((int)0, Killer::kill);

		out << "...";
	}

	out << "*****************";
}

void test40() {
	using namespace Test40;

	Y y;

	X x = y;
}

void test41() {
	using namespace Test41;

	Base b;
	Derived d;

	// illegal
	//d = f(d);

	// illegal
	//d = f1(d);

	try {
		d = dynamic_cast<Derived&>(f1(d));
	} catch (bad_cast) {
		out << "bad cast: dynamic_cast<Derived&>(f1(d))";
	}

	try {
		d = dynamic_cast<Derived&>(f1(b));
	} catch (bad_cast) {
		out << "bad cast: dynamic_cast<Derived&>(f1(b))";
	}
}

class r123 {
public:
	// friend declaration is general declaration 
	// of void f123() too
	friend void f123();
	r123() {
		// this is legal, because f123 is declared above
		// as friend function and as function 
		// simultaneously
		f123();
	}
};

void f123() {};

void test42() {
	using namespace Test42;

	Rational r4(4, 8);

	cout << r4 << endl;

	{
		Rational r4(14, 16);

		cout << r4 << endl;
	}

	{
		Rational r4(748, 12345), r5(567, 8456);

		r4 = r4 + r5;

		cout << "####### " << r4 << endl;
	}

	{
		Rational r4(16, 14);

		cout << r4 << endl;
	}

	Rational r1(1, 2), r2(3, 5);

	out << "__________________";

	// have here 1 constructor and 1 destructor
	// see operator+ to fill the difference
	r1 = r1 * r2;

	out << "__________________";

	cout << r1 << " " << r2 << endl;

	r1 = r1 * 3;

	r2 = 4 * r2;

	cout << r1 << " " << r2 << endl;

	Rational r3(1, 2);

	out << "++++++++++++++++++";

	// have here 2 constructors and 2 destructors
	// see operator* to fill the difference
	r3 = r3 + r3;

	out << "++++++++++++++++++";

	cout << r3 << endl;
}

namespace std {
	class q123 {};
}

void test43() {
	using namespace Test43;

	Base b1(3), b2(5);

	b1 = b2;

	const Base b3(8);

	cout << b1 << b2 << b3;
}

void test44() {
		using namespace Test44;
	
	const int ci = 5;

	int i = 0;

	i = ci;

	const char *cc = "123";

	char *c;

	c; // remove warning

	// illegal
	//c = cc;

	const int *cpi = new int(10);

	int *pi = new int(20);

	// illegal
	//pi = cpi;

	// this is legal but on your risk
	pi = const_cast<int*>(cpi);

	cout << *cpi << endl;

	// illegal
	//*cpi = 30;

	// the value pointed by pointer to constant
	// has been changed
	*pi = 50;

	cout << *cpi << endl;

	cpi = pi;

	const Base b1(3);

	Base b2(b1);

	const Base *pb = &b2;

	pb->out();

	const Base *pb1 = &b1;

	pb1->out();

	// illegal
	//Base *pb2 = &b1;
	
	Base *pb3 = &b2;

	pb3->out();

	cout << *pb3 << *pb1;
}

void test45() {
	using namespace Test45;

	Derived d1, d2;

	out << "-----------------------------------";

	d1 = d2;

	out << "___________________________________";

	Derived d3(d2);

	out << "|||||||||||||||||||||||||||||||||||";

	try {
		DerivedWithExc d;
	} catch (SomeExc) {
		out << "SomeExc 1";
	}

	out << "///////////////////////////////////";

	try {
		SomeClass s;
	} catch (SomeExc) {
		out << "SomeExc 2";
	}

	out << "///////////////////////////////////";
}

class Declared;

void test46() {

	// Pointers & references can be used
	// with only declared classes
	Declared *pd = NULL; // this is legal

	// Objects needs defined classes
	//Declared d; // but this is illegal
}

class Declared {};

void test47() {
	using namespace Test47;

	DerivedPublic dpub;

	f(dpub);

	DerivedProtected dpro;

	dpro; // take out warning

	// illegal - trying to change private 
	// for derived class data
	// f(dpro);

	DerivedPrivate dpri;

	dpri; // take out warning

	// illegal - trying to change private 
	// for derived class data
	// f(dpri);
}

void test48() {
	using namespace Test48;

	Derived d;

	d.f();

	d.test1();

	Base &b = d;

	// illegal
	//b.test1();

	pf f1 = f;

	f1(d);

	int _1 = 5;
}

void test49() {
	using namespace Test49;

	Derived1 d1; d1;

	d1.a;
	//d.b;
	//d.c;

	Derived2 d2; d2;

	//d2.a;
	//d2.b;
	//d2.c;

	Derived3 d3; d3;

	//d3.a;
	//d3.b;
	//d3.c;
}

void test50() {
	using namespace Test50;

	Derived3 d3;

	d3.test();
	d3.testVirtual();

	Derived6 d6;

	d6.test();
	//d6.testVirtual(); // illegal
	//d6.vtest(); // illegal
}