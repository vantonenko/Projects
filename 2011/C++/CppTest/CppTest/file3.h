#pragma once

#include "file1.h"
#include <iostream>
#include <memory>
#include <vector>
#include <list>
#include <map>

using namespace std;

namespace Test83 {
	template<class Map>
	class TestMap {
		int _N;
		Map m;
	public:
		TestMap(int n): _N(n), m() {
			char buf[10];
			for (int i = 0; i < _N; i++) {
				_itoa_s(i, buf, 10);
				m[buf] = i;
			}
		}

		void test() {
			char buf[10];
			for (int i = 0; i < _N; i++) {
				_itoa_s(i, buf, 10);
				m[buf] = 0;
			}
		}
	};
}

namespace Test84{
	template<class T>
	int size(const T &c) {

		// keyword typename isn't necessary here
		// but Meyers recommend to use it
		// in cross-platform code
		//typename T::const_iterator c1 = c.begin(), c2 = c.end();
		T::const_iterator c1 = c.begin(), c2 = c.end();

		return c2 - c1;
	}
}

namespace Test85 {
	// T m[Size] - common array
	template<typename T, int Size>
	void mout(const T (&m)[Size]) {
		for (int i = 0; i < Size; i++) {
			cout.width(10);
			cout << m[i];
		}
		cout << endl;
	}

	// vector, list, set, multiset
	template<class T>
	void mout(const T &cont) {
		for (T::const_iterator it = cont.begin();
							it != cont.end(); it++) {
			cout.width(10);
			cout << *it;
		}
		cout << endl;
	}

	// illegal
	// have to think about decision
	// ???????????????????????????
	// map, multimap
// 	template<class T>
// 	void mout(const T &cont) {
// 		for (T::const_iterator it = cont.begin();
// 							it != cont.end(); it++) {
// 			cout << "(" << it->first << ", " 
// 				<< it->second << ") ";
// 		}
// 		cout << endl;
// 	}
}

namespace Test86 {
	class Base {
	public:
		Base() {
			out << "Base()";
		}
		Base(const Base&) {
			out << "Base(const Base&)";
		}
		Base& operator==(const Base) {
			out << "Base& operator==(const Base)";
			return *this;
		}
		virtual void f() {
			out << "Base::f()";
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
		Derived(const Derived& d): Base(d) {
			out << "Derived(const Derived& d)";
		}
		Derived& operator==(const Derived d) {
			Base::operator ==(d);
			out << "Derived& operator==(const Derived d)";
			return *this;
		}
		virtual void f() {
			out << "Derived::f()";
		}
		~Derived() {
			out << "~Derived()";
		}
	};

	void f() {
		out << "void f()";
	}

	void f(void (*pf)()) {
		pf();
	}

	void f1(void pf()) {
		pf();
	}
}