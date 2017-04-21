#include "stdafx.h"
#include <iostream>
#include "file1.h"
#include "file2.h"
#include <vector>
#include <list>
#include <deque>
#include <set>
#include <map>
#include <stack>
#include <iterator>
#include <conio.h>
#include <algorithm>
#include <numeric> // for accumulate algorithm
#include <math.h>
#include <functional>

using namespace std;

void test73() {
	int m[] = {1, 2, 3, 4, 5};

	vector<int> vi(m, m + 5);

	// the space may not be placed
	// like in vc6.0
	// vector<vector<int> > vvi;
	vector<vector<int>> vvi;

	vvi.push_back(vi);

	cout << vvi[0][1] << endl;
}

void test74() {
	using namespace Test74;

	int m[] = {1, 2, 3};

	Base b(m, m + 3);
}

void test75() {
	using TestBase::Base;

	int ml[] = {1, 2, 3};

	list<Base> lb(ml, ml + 3);

	out << sepp;
	list<Base> lbc(lb);
	out << sepp;

	set<Base> sb(ml, ml + 3);

	out << sepp;
	set<Base> sbc(sb);
	out << sepp;
}

void test76() {
	using namespace Test76;
	map<int, double> m;

	m[3] = 5.1;
	m[2] = 3.4;

	// 	pair<map<int, double>::iterator, bool> iter = 
	// 		m.insert(pair<int, double>(1, 1.7));

	map<int, double>::iterator iter = 
		m.insert(pair<int, double>(1, 1.7)).first;


	out << (*iter).first << (*iter).second;

	out << iter->first << iter->second;

	pair<map<int, double>::iterator, bool> p = 
		m.insert(pair<int, double>(1, 1.7));

	out << p.second << p.first->first << 
		p.first->second;

	// the same as previous
	out << p.second << (p.first)->first << 
		(p.first)->second;

	out << typeid(map<int, double>::value_type).name();

	out << m;

	out << sep_;

	X x;

	x.f(m);

	int im[] = {10, 20, 30, 30, 30, 40, 50, 60};

	multiset<int> si(im, im + 8);

	out << *si.lower_bound(30) << *si.upper_bound(30);

	auto it = find(si.begin(), si.end(), 30);

	out << *it;
}

void test77() {
	map<int, double> m;

	m[23] = 2.3;

	m[11] = 1.1;

	m[34] = 3.4;

	out << m;

	multimap<int, double> mm;

	mm.insert(pair<int, double>(23, 2.3));

	mm.insert(pair<int, double>(11, 1.1));

	mm.insert(pair<int, double>(34, 3.4));

	mm.insert(pair<int, double>(23, 1.3));

	out << mm;
}

void test78() {
	int mi[] = {1, 3, 2, 7, 5};

	vector<int> vi(mi, mi + 5);

	stack<int, vector<int>> svi(vi);

	while (!svi.empty()) {
		out << svi.top();
		svi.pop();
	}

	stack<int> si;

	si.push(10);
	si.push(20);
	si.push(0);

	si.pop();
	si.pop();

	out << si.top();
}

void test79() {
	using namespace Test79;

	int m1[] = {1, 2, 3, 4, 5}, m2[5];

	out << sep_;

	transform(m1, m1 + 5, m2, negate<int>());

	out << m2;

	transform(m1, m1 + 5, m2, Neg());

	out << m1;
	out << m2;

	transform(m1, m1 + 5, m1, Neg());

	out << m1;

	transform(m1, m1 + 5, m1, negate<int>());

	out << m1;

	// Above common array works fine
	// Bellow try to use vector<int>

	vector<int> vi(m1, m1 + 5), vio;

	out << vi;

	transform(vi.begin(), vi.end(), inserter(vio, vio.begin()), negate<int>());

	// gives crash
	//transform(vi.begin(), vi.end(), vio.begin(), negate<int>());

	out << vi;
	out << vio;

	transform(vi.begin(), vi.end(), vi.begin(), negate<int>());

	out << vi;

	// means vio[i] = vi[i] + vio[i]
	transform(vi.begin(), vi.end(), vio.begin(),
		vio.begin(), plus<int>());

	out << vio;

	out << seps;

	vector<Base> vb(m1, m1 + 5);

	out << m1;

	transform(vb.begin(), vb.end(), vb.begin(), negate<Base>());

	out << vb;

	transform(vb.begin(), vb.end(), vb.begin(), Neg());

	out << vb;
}

void test80() {
	using namespace Test80;

	// illegal
	//Derived::xint x;
	Derived d;

	d.xi = 5; // legal but nonsense(?)
}

void test81() {
	using namespace Test81;

	map<int, char*> m;

	m[2] = "two";
	m[4] = "four";

	for_each(m.begin(), m.end(), Func());

	out << m;

	int mi[] = {1, 2, 3, 4, 5, 6, 7, 8};

	list<int> li(mi, mi + 8);

	fill_n(li.begin(), 8, 0);

	out << li;

	fill(li.begin(), li.end(), 1);

	out << li;

	generate(li.begin(), li.end(), BiGen());

	// gives compile error
	//random_shuffle(li.begin(), li.end());

	out << li;

	vector<int> vi(8);

	generate(vi.begin(), vi.end(), BiGen());

	random_shuffle(vi.begin(), vi.end());

	out << vi;
}