#pragma once

#include <iostream>
#include <memory>
#include <vector>
#include <list>
#include <map>
#include <set>
#include <hash_map>

using namespace std;

extern int file1Var;

const int QueueMaxCap = 100;
class QueueBadPutExc {};
class QueueBadGetExc {};

void print(const char*);

template<typename T>
inline bool operator>(const T &x, const T &y) {
	return y < x;
}

class Out {
public:
	// this is replaced by template function
// 	Out& operator<<(const char* s) {
// 		cout << s << endl;
// 		return *this;
// 	}

	template<typename T, int Size>
	Out& operator<<(const T (&vect)[Size]) {
		for (int i = 0; i < Size; i++) {
				cout.width(10);
				cout << vect[i];
		}
		cout << endl;

		return *this;
	}

	// to avoid of calling 
	// Out& operator<<(const T (&vect)[Size])
	// method
	Out& operator<<(const char *s) {
		cout << s << endl;

		return *this;
	}

// try this later
// 	template<typename T>
// 	Out& operator<<(const T &vect) {
// 		for (T::const_iterator iter = vect.begin(); 
// 			iter != vect.end(); iter++) {
// 				cout.width(10);
// 				cout << *iter;
// 		}
// 
// 		cout << endl;
// 
// 		return *this;
// 	}

	template<typename T>
	Out& operator<<(const vector<T> &vect) {
		for (vector<T>::const_iterator iter = vect.begin(); 
			iter != vect.end(); iter++) {
				cout.width(10);
				cout << *iter;
		}

		cout << endl;

		return *this;
	}

	// can this and previous be unified?
	template<typename T>
	Out& operator<<(const list<T> &l) {
		for (list<T>::const_iterator iter = l.begin(); 
			iter != l.end(); iter++) {
				cout.width(10);
				cout << *iter;
		}

		cout << endl;
		return *this;
	}

	template<typename T>
	Out& operator<<(const set<T> &l) {
		for (set<T>::const_iterator iter = l.begin(); 
			iter != l.end(); iter++) {
				cout.width(10);
				cout << *iter;
		}

		cout << endl;
		return *this;
	}

	template<typename T>
	Out& operator<<(const multiset<T> &l) {
		for (multiset<T>::const_iterator iter = l.begin(); 
			iter != l.end(); iter++) {
				cout.width(10);
				cout << *iter;
		}

		cout << endl;
		return *this;
	}

	template<typename T1, typename T2>
	Out& operator<<(const map<T1, T2> &m) {
		for (map<T1, T2>::const_iterator it = m.begin();
			it != m.end(); it++) 
		{
			cout << "(" << it->first << ", " 
				<< it->second << ") ";
		}

		cout << endl;
		return *this;
	}

	template<typename T1, typename T2>
	Out& operator<<(const hash_map<T1, T2> &m) {
		for (hash_map<T1, T2>::const_iterator it = m.begin();
			it != m.end(); it++) 
		{
			cout << "(" << it->first << ", " 
				<< it->second << ") ";
		}

		cout << endl;
		return *this;
	}

	template<typename T1, typename T2>
	Out& operator<<(const multimap<T1, T2> &m) {
		for (multimap<T1, T2>::const_iterator it = m.begin();
			it != m.end(); it++) 
		{
			cout << "(" << it->first << ", " 
				<< it->second << ") ";
		}

		cout << endl;
		return *this;
	}

	template<typename T>
	Out& operator<<(T t) {// reference can't be used here
		cout << t << endl;
		return *this;
	}

	// for separators
	Out& operator<<(Out& (*f)(Out&)) {
		return f(*this);
	}
};

Out& sep_(Out& o);
Out& sept(Out& o);
Out& sepp(Out& o);
Out& sepd(Out& o);
Out& seps(Out& o);

// what is initialized first, cout or out and why?
extern Out out;

class Queue {
private:
	int storage[QueueMaxCap];
	int putPos, getPos, len, t; // temporary value placed here due to not garbage calling stacks of put & get methods

public:
	Queue(): putPos(0), getPos(0), len(0) {};

	void put(int val) {
		if (len < QueueMaxCap)
			storage[len++, t = putPos++, putPos %= QueueMaxCap, t] = val;
		else
			throw QueueBadPutExc();
	}

	int get() {
		if (getPos != putPos)
			return storage[len--, t = getPos++, getPos %= QueueMaxCap, t];
		else
			throw QueueBadGetExc();
	}

	// checks queue for emptiness
	// This makes next construction possible:
	// 		if (q) {val = q.get();}
	operator bool() {
		return getPos != putPos;
	}
};

template <class T> class GQueue {
private:
	T storage[QueueMaxCap];
	int putPos, getPos, len, t; // t - temporary value placed here due to not garbage data stack of put & get methods

public:
	GQueue(): putPos(0), getPos(0), len(0) {};

	void put(T val) {
		if (len < QueueMaxCap)
			storage[len++, t = putPos++, putPos %= QueueMaxCap, t] = val;
		else
			throw QueueBadPutExc();
	}

	T get() {
		if (getPos != putPos)
			return storage[len--, t = getPos++, getPos %= QueueMaxCap, t];
		else
			throw QueueBadGetExc();
	}

	// checks queue for emptiness
	// This makes if (q) {val = q.get();} possible
	operator bool() {
		return getPos != putPos;
	}
};

class A {
	int _m[100];
	int _i;
public:
	A() {
		cout << "Default constructor A is invoked" << endl;
		// destructor for A will not be executed
		// according to throwing exception from 
		// its constructor
		//throw 1;
	}
	A(int i): _i(i) {
		cout << "Constructor A(int) is invoked" << endl;
	};
	A(const A& a) {
		cout << "Copy constructor A is invoked" << endl;
	}
	~A() {
		cout << "Destructor A is invoked." << endl;
	}

	friend A operator+(const A& a, const A& b);

// 	A operator+(const A&) {
// 		cout << "Operator A.+ is invoked" << endl;
// 		return *this;
// 	}

	void operator() () {
		cout << "()" << endl;
	}

	virtual	void f() {
		cout << "A.f()" << endl;
	}

	// this means that Queue::put can access private members of Class A
	// -just for example-
	friend void Queue::put(int);

	static int qwerty;
};

/* 	putting function definition to .h file gives an error:
	"class A const __cdecl operator+(class A const &,class A const &)" (??H@YA?BVA@@ABV0@0@Z) already defined in CppTest.obj"
*/
// const A operator+(const A& a, const A& b) {
// 	cout << "Operator A+A is invoked" << endl;
// 	return A();
// }


class B: public A {
	int k[300];
public:
	B() {
		cout << "Default constructor B is invoked" << endl;
	}

	B(double d) {
		cout << "Constructor B(double) is invoked" << endl;
	}

	B(int i): A(i) {
		cout << "Constructor B(int) is invoked" << endl;
		// illegal, derived class do not have access
		// to private members of the base class
		//_m[0] = 0;
	}

	~B() {
		cout << "Destructor B is invoked" << endl;
	}

	//void operator ->* () {};

	virtual void f() {
		cout << "B.f()" << endl;
	}

	// there can by value instead of reference but that does not have sense, ++ operator should change operand`s value
	friend B operator++(B& b);
};

struct SA {
	int i;
	virtual void f() {
		cout << "SA f()" << endl;
	}
};

struct SB: public SA {
	virtual void f() {
		cout << "SB f()" << endl;
	}
};

class C1 {
	C1() {
		cout << "C1()" << endl;
	};
public:
	C1(int i) {
		cout << "C1(int)" << endl;
	};
};

class C2: public C1 {
public:
	// C1`s default constructor is private
	// so we can invoke only C1(int) constructor
	C2(int i): C1(i) {
		cout << "C2(int)" << endl;
	};
};

// class C2: public C1 {
// public:
// 	C2(int i) { // this is illegal
// 		cout << "C2(int)" << endl;
// 	};
// };

class Class1 {
public:
	explicit Class1(int a = 0, int b = 0) {
		cout << "Class1(int a = 0, int b = 0)" << endl;
	}
	~Class1() {
		cout << "~Class1()" << endl;
	}
};

class Class2 {
public:
	Class2(int a = 0, int b = 0): size1(100), str("initial") {
		cout << "Class2(int a = 0, int b = 0)" << endl;
	}
	~Class2() {
		cout << "~Class2()" << endl;
	}
	Class2& operator=(const Class2& c) {
		cout << "Class2& operator=(const Class2& c)" << endl;
		return *this;
	}

	void fconst() const {
		cout << "fconst()" << endl;
	}

	void fnconst() {
		cout << "fnconst()" << endl;
	}

	const char operator[] (int index) const {
		cout << "const char operator[] (int index) const" << endl;
		return str[index];
	}

	char& operator[] (int index) {
		cout << "char& operator[] (int index)" << endl;
		return str[index];
	}

	const string& getstr() const {
		return str;
	}

private:
	string str;

	// size1, .., size4 - trying to use const instead of #define
	const int size1;
	// constant size1 can't be used for Class2 compilation
	// because its value is set while invoking constructor
	// that's why next statement is illegal
	// int m1[size1];

	static const int size2;
	// constant size2 can't be used for Class2 compilation
	// because its value is not set while compiling Class2
	// that's why next statement is illegal
	// int m2[size1];

	static const int size3 = 100;
	int m3[size3]; // that's ok, but may not be supported by old compilers

	enum {size4 = 100};
	int m4[size4]; // that's ok too
	// ------------------------------------------
};

class Class3 {
	string str;
public:
	Class3(): str("initial value") {};

	// here const and non-const version of function is differ 
	// only by const modifier, body can be the same
	// so next technique can be used
	const char& operator[] (int index) const {
		cout << "Class3::operator[]" << endl;
		return str[index];
	};

	char& operator[] (int index) {
		return const_cast<char&>
			(static_cast<const Class3&>(*this)[index]);
	};
};

class Simple {
public:
	Simple() {
		cout << "Simple()" << endl;
	}
	Simple(int i) {
		cout << "Simple(" << i << ")" << endl;
	}
};

class Comp0 {
	Simple s;
public:
	// here two constructors of Simple class is invoked
	// first Simple(), second Simple(int)
	// Comp1 solve this problem
	Comp0() { 
		s = 1;
	}
};

class Comp1 {
	Simple s;
	// when is it initialized?
	// initialization order is not defined 
	// for different translation`s units.
	static Simple sts;
public:
	// so, field`s constructor with parameters should
	// be invoked in the initialization list to 
	// avoid of unnecessary default constructor invoking
	// like in Comp0
	Comp1(): s(1) { 
		
	}
};

class EA {
public:
	EA() {
		cout << "EA" << endl;
	}
	void f() {
		cout << "EA::f()" << endl;
	}
};

extern EA ea;

class EB {
public:
	EB() {
		// this is invoked
		// before ea initialization.
		// currently it is so, because
		// ea is defined in schildt.cpp
		// eb is defined in file1.cpp
		// both as global variable
		// and eb is initialized first.
		// to avoid this ea & eb should be 
		// local static objects of global functions
		// that return references to it
		// this makes guarantee: object is initialized 
		// before using
		ea.f();
		cout << "EB" << endl;
	}
};

class Class4 {

};

class Class5 {
public:
	Class5(int a, int b) {}
};

class RC{
public:
	RC(int &ii): i(ii) {}
	void f() {
		cout << "RC::F() -> " << i << endl;
	}
private:
	int &i;
};

class Class6 {
	~Class6() {}
};

class NonCopy1 {
public:
	NonCopy1(const NonCopy1&);
	NonCopy1& operator=(const NonCopy1&);
	NonCopy1() {};
};

class NonCopy2 {
	NonCopy2(const NonCopy2&);
	NonCopy2& operator=(const NonCopy2&);
public:
	NonCopy2() {};
};

class UnCopyable {
protected:
	UnCopyable() {}
	virtual ~UnCopyable() = 0;
private:
	UnCopyable(const UnCopyable&);
	UnCopyable& operator=(const UnCopyable&);
};

class NonCopy3: public UnCopyable {
};

namespace Test35 {
	class Base {
	public:
		Base() { 
			// this outputs "class base"
			// even if it's a part of Derived class
			cout << "Base(): " << typeid(*this).name() << endl;
			// this is illegal
			// because VMT has not been completed yet
			// but compiler allows this and Base::vf is invoked
			vf();
		}
		void f() {
			cout << "f(): " << typeid(*this).name() << endl;
		}
		virtual void vf() {
			cout << "vf(): " << typeid(*this).name() << endl;
		}
	};

	class Derived: public Base {
	public:
		Derived() {
			cout << "Derived(): " << typeid(*this).name() << endl;
		}
	};
}

namespace Test36 {
	class Base {
		int *_pi;
		int _size;
	public:
		Base(int size): _size(size) {
			_pi = new int[_size];
			for (int i = 0; i < _size; i++) {
				_pi[i] = i;
			}
		}
		
		Base(const Base &b): _size(b._size) {
			_pi = new int[_size];
			memcpy(_pi, b._pi, sizeof(int) * _size);
		}

		Base& operator=(const Base& b) {
			// check for self-assignment
			// actually we may not check
			// and next code will handle the situation
			// correctly but this will decrease efficiency
			// for such case but in another case there 
			// will not be additional operator if
			// so it depends on how often x = x will be
			// invoked.
			if (&b != this) {
				cout << "delete old array, create copy to new array" << endl;
				int *pt = _pi; // exception-safe
				_size = b._size;
				_pi = new int[_size];
				memcpy(_pi, b._pi, sizeof(int) * _size);
				delete []pt; // exception-safe
			}
			return *this;
		};

		int& operator[](int index) {
			return _pi[index];
		}

		~Base() {
			delete []_pi;
		}
	};
}

namespace Test37 {
	class Ca {};
	class Cb: public Ca {};

	void f1(Ca c1, Ca c2);
	void f1(Cb c1, Cb c2);
}

namespace Test38 {
	class Ca {
	public:
		virtual ~Ca() {};
	};
	class Cb: public Ca {};

	void f1(Ca &c1, Ca &c2);
	void f1(Cb &c1, Cb &c2);
}

namespace Test39 {
	class C {
		int m[1000 * 1000 * 10];
	public:
		void name() {
			print(typeid(*this).name());
		}
		~C() {
			print("~C()");
		}
	};

	class Killer {
	public:
		void operator() (C *c) {
			if (c)
				delete c;
			out << "Killer";
		}
		static void kill(C *c) {
			if (c)
				delete c;
			out << "kill";
		}

		void mfkill(C *c) {
			if (c)
				delete c;
			out << "mfkill";
		}
	};

	void killer(C*);
}

namespace Test40 {
	class X {};

	class Y {
	public:
		operator X() {
			out << "operator X()";
			return X();
		}
	};
}

namespace Test41 {
	class Base {
	public:
		int mB;
		virtual ~Base() {}
	};

	class Derived: public Base {
	public:
		int mD;
	};

	Base f(Base b);
	Base& f1(Base& b);
}

namespace Test42 {
	class ZeroExc {};

	class Rational {
	public:
		Rational(int n = 0, int d = 1): 
		  	numerator(n), denominator(d) {
			normalize();
			out << "Rational(int n, int d)";
		}

		Rational(const Rational& r):
			numerator(r.numerator), 
				denominator(r.denominator) {
			out << "Rational(const Rational& r)";
		}
		
		const Rational& operator=(const Rational& r) {
			numerator = r.numerator;
			denominator = r.denominator;
			out << "const Rational& operator=(const Rational& r)";
			return *this;
		}

		~Rational() {
			out << "~Rational()";
		}
		
		friend const Rational operator*(
			const Rational&, const Rational&);
		
		friend const Rational operator+(
			const Rational&, const Rational&);

		friend ostream& operator<<(
			ostream&, const Rational&);
	private:
		int numerator, denominator;
		void normalize() {
			if (!denominator)
				throw ZeroExc();
			int x = numerator, y = denominator;
			while (x != y && x && y)
				if (x > y)
					x = x % y;
				else
					y = y % x;
			x = (x == 0) ? y : x;
			numerator /= x;
			denominator /= x;
		}
	};

//  declaration is not necessary
//  because its already declared while friend declaring
// 	const Rational operator*(
// 		const Rational &, const Rational &);
}

namespace Test43 {

	// "Copy and swap technique"

	class Base {
	public:
		Base(int size): _size(size), _m(new int[size]) {
			for (int i = 0; i < _size; i++) {
				_m[i] = i;
			}
			out << "Base(int size)";
		}
		Base(const Base &b): _size(b._size), 
			_m(new int[b._size]) {
			for (int i = 0; i < _size; i++) {
				_m[i] = b._m[i];
			}
			out << "Base(const Base &b)";
		}
		// use pass by value to create 
		// the copy of argument
		Base& operator=(Base b) {
			// swap of *this and copy of 
			// argument values
			swap(b);
			out << "Base& operator=(Base b)";
			return *this;
			// here destructor Base destroys 
			// the copy of argument contains 
			// former this`s values
		}
		~Base() {
			delete []_m;
			out << "~Base()";
		}

		friend ostream& operator<<(
			ostream& o, const Base &b);

	private:
		int _size;
		int *_m;
		void swap(Base &b) {
			int *tm = _m;
			_m = b._m;
			b._m = tm;

			int ts = _size;
			_size = b._size;
			b._size = ts;
		}
	};
}

namespace Test44 {
	struct Data {
		int _val1;
		int _val2;
		Data(int v1 = 0, int v2 = 0): 
			_val1(v1), _val2(v2) {}
	};

	class Base {
		int _val;
		Data _d;
		shared_ptr<Data> _shd;
	public:
		Base(int v = 0): _val(v), _shd(new Data) {};
		void out() const {
			cout << "const " << _val << endl;
		}
		void out() {
			cout << "nonconst " << _val << endl;
		}

		// the body of friend function can be defined
		// in class body.
		// that will make friend function inline
		friend ostream& operator<<(
				ostream &o, const Base &b) {
			o << "friend ostream& operator<< " << 
				b._val << endl;
			return o;
		}

		// here reference to int is used 
		// just for example, of course 
		// return by reference is useful for large types
		// but not for embedded

		// this is legal for user & compiler
		const int& test0() const {
			return _val;
		}

		// defined as not inline
		const int& test01() const;

		// defined as inline
		const int& test02() const;

		// defined as inline in header file
		const int& test03() const;

 		// illegal, reference to field from 
		// const function can't be returned
// 		int& test1() const {
// 			return _val;
// 		}

		// this is legal too
// 		int& test2() const {
// 			return _d._val1;
// 		}

		// this is legal for compiler
		// but not for user
		int& test3() const {
			return _shd->_val1;
		}

		// this is legal for user & compiler
		const int& test4() const {
			return _shd->_val1;
		}
	};

	// inline function can be defined in header file
	// try to compile w/o inline - will get error
	inline const int& Base::test03() const {
		return _val;
	}
}

namespace Test45 {

	class SomeExc {};

	class Base {
	public:
		Base() {
			out << "Base()";
		}

		Base(const Base &b) {
			out << "Base(const Base &b)";
		}

		Base& operator=(const Base &b) {
			out << "Base& operator=(const Base &b)";
			return *this;
		}

		~Base() {
			out << "~Base()";
		}
	};

	class Derived: public Base {
	public:
		Derived() {
			out << "Derived()";
		}

		// here Base(d) is specified to handle 
		// Base`s fields, otherwise
		// default constructor of Base is called
		Derived(const Derived& d): Base(d) {
			out << "Derived(const Derived& d)";
		}

		Derived& operator=(const Derived &d) {
			Base::operator=(d);
			out << "Derived& operator=(const Derived &d)";
			return *this;
		}

		~Derived() {
			out << "~Derived()";
		}
	};

	class DerivedWithExc: public Base {
	public:
		DerivedWithExc() {
			out << "DerivedWithExc()";
			
			// destructor for Base & for _b is called
			// after throwing exception while 
			// constructing object
			throw SomeExc(); 

			out << "this will not be displayed";
		}
		~DerivedWithExc() {
			out << "~DerivedWithExc()";
		}
		Base _b;
	};

	class SomeClass {
		Base b;
		DerivedWithExc d;
		Base b1;
	public:
		SomeClass() {
			out << "SomeClass()";
		}
		~SomeClass() {
			out << "~SomeClass()";
		}
	};
}

namespace Test47 {
	class Base {};
	
	class DerivedPublic: public Base {};

	class DerivedProtected: protected Base {};

	class DerivedPrivate: private Base {};

	void f(Base &b);
}

namespace Test48 {
	class Base {
	private:
		//virtual void test1() = 0;
		virtual void test1(int x = 5) = 0;
		virtual void test1(double) = 0;
	public:
		void f() {
			test1();
			test1(1);
			test1(1.0);
		}
	};

	class Derived: public Base {
		int _i;
	public:
// 		virtual void test1() {
// 			out << "test1()";
// 		}

		virtual void test1(int x = 10) {
			// outputs 5
			// because default value is compile time 
			// decision, but some default value should be
			// set here, otherwise compiler don`t find
			// test1() function
			cout << "test1(int x = 10) " << x << endl;
		}

		virtual void test1(double x) {
			out << "test1(double x)";
		}

		friend void f(const Derived &d) {
			cout << "friend void f() " << d._i << endl;
		}
	};

	typedef void (*pf)(const Derived &d);
}

namespace Test49 {
	class Base {
	public:
		int a;
	protected:
		int b;
	private:
		int c;
	};

	class Derived1: public Base {
	public:
		void f() {
			a;
			b;
			//c;
		}
	};

	class Derived2: protected Base {
	public:
		void f() {
			a;
			b;
			//c;
		}
	};

	class Derived3: private Base {
	public:
		void f() {
			a;
			b;
			//c;
		}
	};
}

namespace Test50 {
	class Base {
		int _val;
	public:
		// this default constructor can't be disabled
		// due to multiple inheritance
		Base() {
			out << "Base()";
		}
		
		explicit Base(int val): _val(val) {
			out << "Base(int)";
		}
		
		int val() const {
			return _val;
		}
		
		int& val() {
			return _val;
		}

		virtual void vtest() {
			out << "Base::vtest()";
		};

		void testVirtual() {
			vtest();
		}

		~Base() {
			out << "~Base()";
		}
	};

	class Derived1: virtual public Base {
	public:
		Derived1(): Base(3) {
			// outputs non-initialized value
			// Base(3) calling is ignored
			cout << val() << endl;
			out << "Derived1()";
		}

		virtual void vtest() {
			out << "Derived1::vtest()";
		}

		~Derived1() {
			out << "~Derived1()";
		}
	};

	class Derived2: virtual public Base {
	public:
		Derived2(): Base(8) {
			// outputs non-initialized value
			// Base(8) calling is ignored
			cout << val() << endl;
			out << "Derived2()";
		}

		// illegal, can't override virtual function
		// in Derived1 & Derived2 simultaneously
// 		virtual void vtest() {
// 			out << "Derived2::vtest()";
// 		}

		~Derived2() {
			out << "~Derived2()";
		}
	};

	#pragma warning( disable : 4250 )
	class Derived3: public Derived1, public Derived2 {
	public:
		Derived3() {
			out << "Derived3()";
		}

		void test() {
			Derived1::val() = 5;

			// outputs 5 too
			cout << Derived2::val() << endl;
		}

		~Derived3() {
			out << "~Derived3()";
		}
	}; // C4250 warning

	class Derived4: public Base {
	public:
		Derived4() {
			out << "Derived4()";
		}

		virtual void vtest() {
			out << "Derived4::vtest()";
		}

		~Derived4() {
			out << "~Derived4()";
		}
	};

	class Derived5: public Base {
	public:
		Derived5() {
			out << "Derived5()";
		}

		virtual void vtest() {
			out << "Derived5::vtest()";
		}

		~Derived5() {
			out << "~Derived5()";
		}
	};

	class Derived6: public Derived4, public Derived5 {
	public:
		Derived6() {
			out << "Derived3()";
		}

		void test() {
			Derived4::val() = 5;

			// outputs another value
			// due to non-virtual inheritance
			cout << Derived5::val() << endl;
		}

		~Derived6() {
			out << "~Derived3()";
		}
	};
}

namespace Test51 {
	template<typename T>
	ostream& operator<<(ostream &o, const vector<T> &vect) {
		for (vector<T>::const_iterator iter = vect.begin(); 
			iter != vect.end(); iter++) {
				o.width(8);
				o << *iter;
		}

		o << endl;

		return o;
	}
}

namespace Test57 {
	class Base {
	public:
		Base(int) {
			out << "Base(int)";
		}
		Base() {
			out << "Base()";
		}
		Base(const Base&) {
			out << "Base(const Base&)";
		}
		Base& operator=(const Base&) {
			out << "Base& operator=(const Base&)";
			return *this;
		}
		~Base() {
			out << "~Base()";
		}
	};
}

namespace TestBase {
	class Base {
		int _val;
	public:
		Base(int val = 0): _val(val) {
			out << "Base(int)";
		}
		Base(const Base& b): _val(b._val) {
			out << "Base(const Base&)";
		}
		Base& operator=(const Base& b) {
			_val = b._val;
			out << "Base& operator=(const Base&)";
			return *this;
		}
		bool operator==(const Base &b) const {
			out << "bool operator==(const Base &b)";
			return _val == b._val;
		}
		// unary "-"
		const Base operator-() {
			return Base(-_val);
		}
		// had better create friend function
		// to make 1 < Base() and Base() > 1
		// operations possible
// 		bool operator<(const Base &b) const {
// 			out << "bool operator<(const Base &b)";
// 			return _val < b._val;
// 		}
		int& operator*() {
			out << "int& operator*()";
			return _val;
		}
		friend bool operator<(const Base &b1,
								const Base &b2) {
			out << "bool operator<(const Base &b)";
			return b1._val < b2._val;
		}
		friend const Base operator+(const Base &b1, 
									const Base &b2) {
			out << "const Base operator+(const Base &b1, const Base &b2)";
			return Base(b1._val + b2._val);
		}
		friend ostream& operator<<(ostream& o,
						const Base &b) {
			o << b._val;
			return o;
		}
		~Base() {
			out << "~Base()";
		}
	};
}

namespace Test62 {
	class RevComp {
	public:
		bool operator() (int x, int y) {
			return x > y;
		}
	};
}

namespace Test64 {
	// this is illegal
	// function can be deduced by argument list only
	template<typename T>
	T func() {
		;
	}
}

namespace Test65 {
	class Greater4 {
	public:
		bool operator() (int val) {
			return val  > 4;
		}
	};
}

namespace Test71 {
	template<typename T1, typename T2>
	class Base {
	public:
		void f1(const T1 &t1, const T2 &t2) {
			cout << typeid(*this).name() << "::f1" << endl;
			out << t1 << t2;
		}
	};

	template<typename T>
	class Base<bool, T> {
	public:
		void f2(bool b, const T &t) {
			cout << typeid(*this).name() << "::f2" << endl;
			cout << boolalpha;
			out << b << t;
		}
	};
}

namespace Test72 {
	using namespace TestBase;
// 	class Base {
// 		int _val;
// 	public:
// 		Base(int val): _val(val) {
// 			out << "Base(int)";
// 		}
// 		Base(const Base &b): _val(b._val) {
// 			out << "Base(const Base &b)";
// 		}
// 		Base& operator=(const Base &b) {
// 			_val = b._val;
// 			out << "Base& operator=(const Base&)";
// 			return *this;
// 		}
// 		~Base() {
// 			out << "~Base()";
// 		}
// 		friend ostream& operator<<(ostream& o,
// 									const Base &b) {
// 			o << b._val;
// 			return o;
// 		}
// 	};
}

namespace Test74 {

	// this class is not so good as Base
	// next code can't be compiled
	// 	int m[] = {1, 2, 3};
	// 	Base0 b(m, m + 3);
	class Base0 {
		vector<int> v;

		typedef vector<int>::iterator _Iter;
	public:
		Base0(const _Iter i0, 
				const _Iter i1): v(i0, i1) {}
	};

	// this is more useful
	class Base {
		vector<int> v;
	public:
		template<typename _Iter>
		Base(const _Iter i0, 
			const _Iter i1): v(i0, i1) {}
	};
}