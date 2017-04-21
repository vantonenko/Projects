// CppTest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "file1.h"
#include "file2.h"
#include "file3.h"
#include <vector>
#include <list>
#include <deque>
#include <set>
#include <map>
#include <hash_map>
#include <stack>
#include <iterator>
#include <conio.h>
#include <algorithm>
#include <numeric> // for accumulate algorithm
#include <math.h>
#include <functional>
#include <string>

#include <Windows.h>

using namespace std;

void test82() {
	map<const char*, int> m;

	m["one"] = 1;
	m["two"] = 2;
	m["three"] = 3;
	m["four"] = 4;
	m["five"] = 5;

	auto itm = m.begin();

	out << itm->first << itm->second;

	itm++;

	out << itm->first << itm->second;

	// illegal
	//auto it = s.begin() + 3;

	int im[] = {1, 2, 3};

	set<int> s(im, im + 3);

	auto its = s.begin();

	out << *its;

	// illegal
	//its += 2;

	vector<int> v(im, im + 3);

	// legal
	auto itv = v.begin() + 2;
}

void test83() {
	using namespace Test83;

	// hash_map is a member of std namespace
	//std::hash_map

	const int N = 1000000;

	out << "Create map<string, int>";

	TestMap<map<string, int>> m(N);

	out << "Create hash_map<string, int>";

	TestMap<hash_map<string, int>> hm(N);

	out << "Start test for map<string, int>";

	m.test();

	out << "Start test for hash_map<string, int>";

	// it's strange but this needs more time than m.test()
	// ???????????
	hm.test();
}

void test84() {
	using namespace Test84;

	vector<int> v(10, 0);

	out << size(v);

	vector<int> vi;
	list<int> li;
	set<int> si;
	map<int, int> mi;

	//vi.equal_range(1); // illegal
	//li.equal_range(1); // illegal
	si.equal_range(1);
	mi.equal_range(1);

	int im[] = {100, 20, 30, 30, 30, 40, 50, 60};

	multiset<int> msi(im, im + 8);

	out << msi; // see sorted output
}

void test85() {
	using namespace Test85;

	int im[] = {1, 2, 3, 4, 5, 6, 7, 8};

	vector<int>		vi(im, im + 8);
	list<int>		li(im, im + 8);
	set<int>		si(im, im + 8);
	//	map<int, int>	mi;

	// 	mi[0] = 0;
	// 	mi[1] = 1;

	mout(im);
	mout(vi);
	mout(li);
	mout(si);
	//	mout(mi);
};

void test86() {
	using namespace Test86;

	{
		typedef shared_ptr<Base> SmartPtr;

		vector<shared_ptr<Base>> v;

		v.push_back(SmartPtr(new Base()));
		v.push_back(SmartPtr(new Derived()));

		v[0]->f(); // have Base::f()
		v[1]->f(); // have Derived::f()

		// All Base & Derived objects are destroyed
		// in SmartPtr destructor
	}

	out << sep_;

	{
		vector<Base> v;

		v.push_back(Base());
		v.push_back(Derived());

		v[0].f(); // have Base::f()
		v[1].f(); // have Derived::f()
	}

	out << sept;

	f(f);

	f1(f);

	out << "Enter the sequence of numbers ended by Ctrl+Z";

	// gives(!) definition of function lin
	// compiler gives warning C4930
	// 	list<int> lin(istream_iterator<int>(cin), 
	// 					istream_iterator<int>());

	// using of additional () is needed to fix
	// this mis-compiling
	list<int> lin((istream_iterator<int>(cin)), 
		istream_iterator<int>());

	lin.sort();

	out << lin;

	// compiler allows using containers of 
	// auto_ptr, but generally this is illegal
	// due to next:
	// auto_ptr a(p1), b;
	// b = a; - after that a points to nothing
	// "a" has given undivided owning of p1 to b
	vector<auto_ptr<Base>> v;

	//allocator<int>::construct

	char* str = "\u043f\u0440\u0438\u0432\u0435\u0442\u043c\u0438\u0440";

	out << str;
}

int primesCSharp(int);

void f(char *p = "name")
{
	cout << p << endl;
}

namespace ASHL {
	class A
	{
	public:
		operator int() const {return (1);}
	};

	class B: public A
	{
	public:
		B(const B &b) {}
		B() {}
	};
}

void test9ashl()
{
	ASHL::A a;
	//ASHL::B b(a);
	ASHL::B b;

	ASHL::A a2(b);

	int i = b;
}

int _tmain(int argc, _TCHAR* argv[])
{
	cout << "Start computing..." << endl;

	DWORD startTime = GetTickCount();
	
	cout << primesCSharp(1000 * 1000 * 100) << endl;

	DWORD endTime = GetTickCount();

	cout << "Finish." << endl;

	cout << "Time: " << endTime - startTime << endl;

	f();
	f("123");

	return 0;
}