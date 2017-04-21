#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <iomanip> 		//setw()
#include "file1.h"
#include <windows.h> 	// GetTickCount()
#include <conio.h> 		// getch()

using namespace std;

A fA() {
	A a;
 	return a;
}

void func1(int *&x) {
	x = NULL;
}

void func2(char *strDict1[][2]) {
	//int i = strDict1;
}

int myStrLen(char *s) {
	int i = 0;
	while (*s++) i++;
	return i;
}

void swap(int &x, int &y) {
	x = x + y;
	y = x - y;
	x = x - y;
}

// int& func() {
// 	int i = 0;
// 	return i; // This is illegal and gives a warning.
// }

void overFunc(double x) {
	;
}

// void overFunc(float x) {
// 	;
// }

void test0() {
	A *pa0 = new B;

	A *pa1 = new A;

	B *pb = new B;

	cout << "_________________" << endl;

	// sizeof is a compile-time operator!!
	cout << sizeof *pa0 << " " << typeid(*pa0).name() << endl; 	// have 404 class B!!!
	cout << sizeof *pa1 << " " << typeid(*pa1).name() << endl; 	// have 404 class A
	cout << sizeof *pb << " " << typeid(*pb).name() << endl; 	// have 1604 class B

	cout << "~~~~~~~~~~~~~~~~~" << endl;

	delete pa0;
	delete pa1;
	delete pb;

	cout << ((-2) << 1) << endl;

	cout << ((-4) >> 1) << endl;
	
	cout << file1Var << endl;

	double	d = 0.0;
	float	f = 0.0;

	overFunc(d);
	overFunc(f);
	overFunc('c');
	
	int i = 0;
	int &ri = i;
	int *pi = &ri;
	int &rri = ri;

	cout << &i << endl;
	cout << pi << endl;

	int x = 5, y = 10;

	swap(x, y);

	cout << x << " " << y << endl;
	
// 	cout << myStrLen("123") << endl;
// 	
// 	for (int i = 0; i < argc; i++) {
// 		wcout << argv[i] << endl;
// 	}
// 
// 	int j = 0;
// 	int *i = &j;
// 
// 	cout << i << endl;
// 
// 	func1(i);
// 
// 	cout << i << endl;
// 
// 	int m[] = {0, 1, 2, 3, 4};

	//func1(m); // it`s illegal.

	cout << "#########################" << endl;

	{
		cout << "^^^^^^^^^^^^^^^^^^^^^^^^" << endl;
		A s = fA() + fA();
	}

	cout << "#########################" << endl;

	// both of these are the same:
	char strArr0[][4] = {"123", "456", "789"};
	char *strArr1[] = {"123", "456", "789"};
	//char *(strArr1[]) = {"123", "456", "789"}; //	- it`s valid too

	cout << strArr0[2] << endl;
	cout << strArr1[2] << endl;

 	char *strDict0[][2] = {
		"123", "0",
		"123", "1",
		"456", "0",
		"456", "1"
 	};

	cout << strDict0[0][0] << endl;
	cout << strDict0[0][1] << endl;

	char strDict1[][2][4] = {
		"123", "0",
		"123", "1",
		"456", "0",
		"456", "1",
		"789", "0",
		"789", "1",
	};
	
	A am[3] = {1, 2, 3};	// array of objects can be initialized
	
	cout << strDict1[0][0] << endl;
	cout << strDict1[0][1] << endl;
}

void test1() {
	A a, b;

	a = b + 2;
}

int sum(int x, int y) {
	static int f = 0;

	if (f)
		return y;

	f = 1;

	int s = x + sum(x, y); // adding this call makes twice longer the time of executing of the function
	//int s = x + y;

	f = 0;
	return s;
}

void test2() {

	DWORD t0 = GetTickCount();

	int supersum = 0;

	for(int i = 0; i < 100000000; i++) {
		supersum += sum(supersum, i);
	}

	cout << "Spent time is: " << GetTickCount() - t0 << endl;
};

void test3() {
	Queue	q;

	for (int j = 0; j < 5; j++) {
		for (int i = 0; i < 30; i++) {
			q.put(i);
		}
		for (int i = 0; i < 30; i++) {
			cout << q.get() << endl;
		}
		cout << "__________" << endl;
	}
}

void func3(A a) {

}

void test4() {
	func3(A() + 1); // ???????
}

void test5() {
	int i = 0, j = 0;

	const int *pi = &i;

	pi = &j;

	//*pi = 1; // this is illegal because of pi points to const int
	//*(pi + 1) = 2; // illegal too, pi + 1 points to const int

	int *const pj = &j;

	*pj = 1;

	//pj = &i; // this is illegal because of pj is a constant

	const int k = 0;

	//int *pk = &k; // this is illegal because of pk points to int but k is const int
}

// A& func4() {
// 	A a;
// 
// 	return a; 	// this is illegal, get warning about returning the reference to local object
// }

A func5() {
	A a;

	return a;
}

void test6() {
	B b;

	cout << "_______" << endl;

	B b1 = b;

	cout << "_______" << endl;

	B bd = 1.0;

	cout << "_______" << endl;

	B bi = 1;
}

void test7() {
/*	The only difference between structures and classes is
	the fact that by default classes has private members and
	structures - public.*/
	SA *ps = new SB;

	ps->f();
}

static union { // global anonymous unions must be declared static
	unsigned int ii;
	unsigned char mm[4];
};

void test8() {
	union {
		unsigned int i;
		unsigned char m[4];
	};

	m[0] = 255;
	m[1] = 255;
	m[2] = 255;
	m[3] = 255;

	cout << i << endl; // outputs 4294967295
}

//????
void test9() {
	A a;

	// invokes A.+
	a = 1 + a;

	// invokes A+A, should only this one be left as + operator?
	a = a + 1;
}

void test10() {
	C2 c(1);

	//C1 cc; // this illegal
}

// ti`s illegal: 'operator ++' must have at least one formal parameter of class type
// int operator++(int &i, int) {
// 	i = i + 1;
// 	cout << "i++" << endl;
// 	return i;
// }

void test11() {
	B b;

	++b;
}

void test12() {
	A a;

	// what for is it (ability to overload () operator)? -
	// This gives an ability to create object-function.
	a();
}

void test13() {
	int a = 5;

	cout << (a += 5) << endl;

	(a += 5) = 20;

	cout << a << endl;

	(a = a + 5) = 30;

	cout << a << endl;

	//(a + 5) = 40; // it`s illegal
}

void test14() {
	B b[2];

	A *pa = b;

	pa->f();

	pa++;

	// that gives run-time error, pa is increased on class A size but not on class B
	pa->f();
}

void test15() {
	cin >> hex;

	fstream fstr("d:\\out.txt");

	// here "operator void *()" is used to create
	// custom cast from fstream to (void *)
	// if (condition) eats (void *) type casting it to bool
	if (fstr) {
		fstr << "123" << endl;
	}

	cout << boolalpha;

	Queue q;

	// Queue::operator bool() makes this possible
	if (!q) {
		cout << "q is empty, q is " << q << endl;
	}

	q.put(10);

	if (q) {
		cout << "q is not empty, q is " << q << endl;
	}

	q.get();

	if (!q) {
		cout << "q is empty again, q is " << q << endl;
	}

	ifstream in("d:\\eula.1028.txt");
	char ch;

	while(in.get(ch)) cout << ch;
}

// put it here due to not overloading stack.
char buf[1000*1000*100];

void test16() {
	ifstream iFile("d:\\source.dat", ios::binary);
	ofstream oFile("d:\\copy.dat", ios::binary);

	cout << "Press any key to start..." << endl;
	_getch();

	cout << "Start..." << endl;

	DWORD t0 = GetTickCount();
	std::streamsize fsize = 0;

	// this loads CPU too much in comparison with 
	// copying file using Windows Explorer 
	// also copying speed is lower than while using explorer
	// some system functions should be used instead
	while (iFile) {
		iFile.read(buf, sizeof buf);
		oFile.write(buf, iFile.gcount());

		// this can be calculated something like - GetSize(filepath)
		fsize += iFile.gcount();
	};

	double seconds = (GetTickCount() - t0) / 1000.0;

	cout << "Stop." << endl;

	if (fsize)
		cout << fsize / seconds	/ 1024.0 / 1024.0 << " Mb/s" << endl;

	ios::iostate state = cout.rdstate();
}

void test17() {
	try {
		A a;
		{
			A a;
			{
				A a;
				throw 5;
				B b;
			}
			B b;
		}
		B b;
	} catch (int) {
		cout << "exception int is caught" << endl;
	}

	// 	try {
	// 		A a;
	// 		{
	// 			A a;
	// 			{
	// 				A a;
	// 				throw 'c';
	// 				B b;
	// 			}
	// 			B b;
	// 		}
	// 		B b;
	// 	} catch (int) {
	// 		// this do not handle char exception
	// 		// so there is no implicit cast char->int
	// 		cout << "exception int is caught" << endl;
	// 	}

	// 	try {
	// 		A a;
	// 		{
	// 			A a;
	// 			{
	// 				A a;
	// 				short int i;
	// 
	// 				throw i;
	// 				B b;
	// 			}
	// 			B b;
	// 		}
	// 		B b;
	// 	} catch (int) {
	// 		// this do not handle char exception
	// 		// so there is no implicit cast (short int)->int
	// 		cout << "exception int is caught" << endl;
	// 	}
}

void test18() {
		try {
		throw A();
	} catch (A) {
		cout << "Exception A has been caught" << endl;
		// have two destructors A invoked
		/*	Default constructor A is invoked
			Copy constructor A is invoked
			Exception A has been caught
			Destructor A is invoked.
			Destructor A is invoked.
			Для продолжения нажмите любую клавишу . . .*/
	}

	cout << "______________" << endl;

	try {
		throw A();
	} catch (A &) {
		cout << "Exception A has been caught" << endl;
		// have one destructor A invoked
		/*	Default constructor A is invoked
			Exception A has been caught
			Destructor A is invoked.
			Для продолжения нажмите любую клавишу . . .*/
	}

	cout << "_____________" << endl;

	try {
		A a;
		// this invokes copy constructor even if 
		// we have reference in catch block
		throw a; 
	} catch (A&) {
		cout << "Exception A has been caught" << endl;
	}
}

void test19() {
	try {
		// catch (A) handles this exception because
		// A is a base class for B
		throw B();
	} catch (A&) {
		cout << "Exception A has been caught" << endl;
	}

	// 	try {
	// 		// catch (A) handles this exception because
	// 		// A is a base class for B
	// 		throw B();
	// 	} catch (A) {
	// 		// this gives warning, because A is met first
	// 		// in exception catching order
	// 		cout << "Exception A has been caught" << endl;
	// 	} catch (B) {
	// 		cout << "Exception B has been caught" << endl;
	// 	}

	try {
		// catch (B) handles this exception
		throw B();
	} catch (B) {
		cout << "Exception B has been caught" << endl;
	} catch (A) {
		cout << "Exception A has been caught" << endl;
	}

	B b;
	B *pb = &b;
	try {
		// catch (A*) handles this exception because
		// A is a base class for B
		throw pb;
	} catch (A*) {
		cout << "Exception A has been caught" << endl;
	}
}

void test20() {
	try {
		throw A();
	} catch (A) { // this don`t give copy constructor
		cout << "A" << endl;
	}

	try {
		throw A();
	} catch (A&) { // this don`t give copy constructor too
		cout << "A" << endl;
	}

	try {
		throw A();
	} catch (A a) { // this gives copy constructor
		cout << "A" << endl;
		a.f();
	}

	try {
		throw A();
	} catch (A &a) { // this don`t give copy constructor
		cout << "A" << endl;
		a.f();
	}

	try {
		A a;
		throw a;
	} catch (A a) { // this gives 2 copy constructors
		cout << "A" << endl;
		a.f();
	}

	try {
		A a;
		throw a;
	} catch (A &a) { // this gives 1 copy constructor
		cout << "A" << endl;
		a.f();
	}
}

// throw means that there are no exceptions 
// thrown outside from the body of this function
void eFunc0() throw() {
	cout << "eFunc0" << endl;
}

void eFunc1() throw() {
	cout << "eFunc0" << endl;
	// this gives warning C4297: function assumed not to throw an exception but does
	//throw 1;
}

void eFunc2() throw(...) {
	cout << "eFunc0" << endl;
	throw 'c';
}

// This gives warning C4290: C++ exception specification 
// ignored except to indicate a function is 
// not __declspec(nothrow)
// void eFunc3() throw(int, char) {
// 	cout << "eFunc0" << endl;
// }

void test21() {
	try {
		try {
			throw B();
		} catch (B) {
			// this throws exception B again
			// and move out from current block
			// to find the appropriate catch
			// not "catch (A) 0"
			throw;
		} catch (A) {
			cout << "catch (A) 0" << endl;
		}
	} catch (A) {
		cout << "catch (A) 1" << endl;
	} 
}

void test22() {
	try {
		throw; // what will be happened? - nothing good
	} catch (...) {
		cout << "catch (...)" << endl;
	}
}

void test23() {
	{
		GQueue<int> q;

		for (int j = 0; j < 5; j++) {
			for (int i = 0; i < 30; i++) {
				q.put(i);
			}
			for (int i = 0; i < 30; i++) {
				cout << q.get() << endl;
			}
			cout << "__________" << endl;
		}
	}

	cout << scientific;

	{
		GQueue<double> q;

		for (int j = 0; j < 5; j++) {
			for (int i = 0; i < 30; i++) {
				q.put(i);
			}
			for (int i = 0; i < 30; i++) {
				cout << q.get() << endl;
			}
			cout << "__________" << endl;
		}
	}
}

enum xEnum {q, w, e, r, t, y};

void fEnum(xEnum e) {
	cout << "xEnum" << endl;
}

void fEnum(int e) {
	cout << "int" << endl;
}

void fEnum(short int) {
	cout << "short int" << endl;
}

void test24() {
	fEnum(w);
	fEnum(5);
	fEnum((short int)5);
}

void test25() {
	try {
		int *m = new int[1000 * 1000 * 500]; // throws exception bad_alloc
		//int *m1 = new int[1000 * 1000 * 1000]; // - gives compile error:  total size of array must not exceed 0x7fffffff bytes (2Gb)
		cout << "Memory is allocated" << endl;
	} catch (bad_alloc) {
		// goes here because 2 000 000 000 Bytes can`t be allocated
		cout << "Can`t allocate enough memory" << endl;
	}
}

void test26() {
	int *m = new int[1000 * 1000 * 200];

	for (int i = 0; i < 1000 * 1000 * 200; i++) {
		m[i] = i * i;
	}

	memset(m, 0, sizeof(int[1000 * 1000 * 200]));

	delete []m;
}

// namespace {
// 	int x = 0;
// }

namespace NX {
	int x = 1;
}

void test27() {
	//cout << x << endl;;;
	using namespace NX;
	cout << NX::x << endl;
}

using NX::x;

void test28() {
	cout << A::qwerty << endl;

	cout << x << endl;
}

void test29() {
	A 	a;
	A 	*pa = &a;
	A	&ra = a;
	cout << (typeid(a) == typeid(pa)) << endl;
	cout << (typeid(a) == typeid(*pa)) << endl;
	cout << (typeid(a) == typeid(ra)) << endl;
	cout << (typeid(pa) == typeid(ra)) << endl;

	cout << typeid(a).name() << endl;
	cout << typeid(pa).name() << endl;
	cout << typeid(ra).name() << endl;

	cout << (typeid(A) == typeid(a)) << endl;
	cout << (typeid(A*) == typeid(pa)) << endl;
	cout << (typeid(A&) == typeid(ra)) << endl;
	cout << (typeid(A) == typeid(A&)) << endl; 
}

void test30() {
	A a;
	B b;

	A *p1 = &a, *p2 = &b;
	A &r1 = a, &r2 = b;

	cout << typeid(p1).name() << endl;
	cout << typeid(p2).name() << endl;

	cout << typeid(*p1).name() << endl;
	cout << typeid(*p2).name() << endl;

	cout << typeid(r1).name() << endl;
	cout << typeid(r2).name() << endl;

	p1 = NULL;

	try {
		cout << typeid(*p1).name() << endl;
	} catch (bad_typeid &e) {
		cout << "p1 is NULL" << endl;
		cout << e.what() << endl;
	}
}

void test31() {
	int *pi = NULL;

	try {
		cout << *pi << endl; // Gives crash, exception isn't invoked
	} catch (...) {
		cout << "Crash" << endl;// Doesn't go here
	}
}

unsigned short hash( void *p ) {
	unsigned int val = (unsigned int)p;
	return ( unsigned short )( val ^ (val >> 16));
}

void test32() {
	A a;
	B b;

	A *pb = &b;

	B *p1 = dynamic_cast<B*>(pb);

	cout << (p1 == NULL) << endl;

	A *p2 = dynamic_cast<A*>(p1); // this can be done w/o dynamic_cast

	cout << (p2 == NULL) << endl;

	A *p3 = p1; // w/o dynamic_cast

	//B *p4 = pb; // illegal, can't convert from A* to B*

	int i = (int)p1; // this invokes static_cast if can't then invokes reinterpret_cast
}

//EB eb;
EA ea;