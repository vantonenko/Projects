#pragma once

#include "file1.h"
#include <iostream>
#include <memory>
#include <vector>
#include <list>
#include <map>

using namespace std;

// this is illegal for vc6.0
template<typename T, int Size>
void outm(const T (&m)[Size]) {
	for (int i = 0; i < Size; i++) {
		cout << m[i] << " ";
	}
	cout << endl;
}

namespace Test76 {
	class X {
	public:
		template<typename T1, typename T2>
		void f(const map<T1, T2> &m) {
			out << "void f(const map<T1, T2> &m)";
		}
	};
}

namespace Test79 {
	class Base {
		int _val;
	public:
		Base(int val = 0): _val(val) {}
		const Base operator-() const {
			return Base(-_val);
		}
		friend ostream& operator<<(ostream &o, 
					const Base &b) {
			o << b._val;
			return o;
		}
	};

	class Neg {
	public:
		template<typename T>
		const T operator()(const T &x) {
			return -x;
		}
	};
}

namespace Test80 {
	class Base {
		typedef char xchar;
	public:
		typedef int xint;
	};

	class Derived: Base {
		//xchar xc1; // illegal
	public:
		xint xi;
		//xchar xc2; // illegal
	};
}

namespace Test81 {
	class Func {
	public:
		template<typename T>
		void operator() (T &x) {
			out << x.first << x.second;
		}
	};

	class BiGen {
		int val;
	public:
		BiGen(): val(1) {}
		int operator() () {
			return val *= 2;
		}
	};
}