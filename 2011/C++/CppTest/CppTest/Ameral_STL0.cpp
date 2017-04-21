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

void test51() {
	using namespace Test51;

	const int Size = 320;

	vector<double> vect;

	for (int i = 0; i < Size; i++)
		vect.push_back(cos((double)i * i) * Size);

	cout << vect; // executes non-member function

	sort(vect.begin(), vect.end());

	out << vect;

	out << "_____________________";
}

void test52() {
	const int Size = 10000000;

	vector<double> vect;

	for (int i = 0; i < Size; i++)
		vect.push_back(cos((double)i) * Size);

	out << "find";

	vector<double>::iterator fIter = find(vect.begin(), vect.end(), vect[Size - 1]);

	//out << vect;

	out << "Press any key to start sorting";

	_getch();

	sort(vect.begin(), vect.end());

	//out << vect;

	out << "_____________________";
}

void test53() {
	int m[] = {2, 8, 3, 6, 3, 8, 5};

	// this algorithm can be used with common pointers
	// in addition to using with iterators
	// pointers is iterators to by the way
	sort(m, m + 7);

	out << "____________";
	for (int i = 0; i < 7; i++) {
		out << m[i];
	}
}

void test54() {
	vector<int> v;
	int 		x;

	out << "Enter the sequence of numbers ended by 0";

	while (cin >> x, x != 0)
		v.push_back(x);

	for (vector<int>::iterator i = v.begin();
		i != v.end(); i++)
		out << *i;
}

void test55() {
	bool b;

	b;

	out << typeid(b).name();

	int m[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};

	vector<int> v(m, m + 13);

	for (vector<int>::iterator i = v.begin();
		i != v.end(); i++)
		out << *i;

	v.pop_back(); // erase last element

	vector<int>::iterator it = v.begin();

	it += 2;

	// this is more effective in list
	// here linear time is used
	// in list const time is used
	v.erase(it); // erase element #3

	out << v;

	// gives crash
	// iterators should be recalculated
	// after changing the container?
	// iterators for vector should be 
	// recalculated after:
	// 	- memory reallocation
	//		(method reserve can be used to avoid reallocation)			
	// 	- erasing, inserting elements 
	//		(if iterator points to moved element)
	// v.erase(it, it + 2);

	v.erase(v.begin() + 2, v.begin() + 4);

	out << v;
}

void test56() {
	cout << "Enter the sequence of numbers ended by 0: ";

	vector<int> vect;
	int val;

	while (cin >> val, val != 0)
		vect.push_back(val);

	sort(vect.begin(), vect.end());

	// here out << vect can be used instead
	for (vector<int>::iterator it = vect.begin();
		it != vect.end(); it++)
		cout << *it << " ";

	cout << endl;
}

void test57() {
	using namespace Test57;

	int m[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

	vector<int> v1(m, m + 9);

	vector<int> v2(v1);

	// surprisingly,
	// implicit cast must be used here
	vector<double> v3(v1.begin(), v1.end());

	out << v3;

	//vector<double> v4(v1); // illegal

	list<int> l1(v1.begin(), v1.end());

	// gives warning: data may be lost
	// while conversation from double to int
	//list<int> l2(v3.begin(), v3.end());

	list<double> l3(v1.begin(), v1.end());

	out << "______________________";

	// this 5 times invokes
	// 	Base()
	//	Base(const Base&)
	//	~Base()
	// and while destroying vb ~Base() 5 times is invoked
	vector<Base> vb(5);

	out << "_______________________";

	// this invokes
	//	Base(int)
	//	Base(const Base&)
	//	Base(const Base&)
	//	Base(const Base&)
	//	~Base()
	// and while destroying vb ~Base() 3 times is invoked
	vector<Base> vbi(3, 0);

	list<Base> l;

	out << "_______________________";

	copy(vbi.begin(), vbi.end(), inserter(l, l.begin()));

	out << l.size();
}

void test58() {
	int m[] = {1, 2, 3, 4, 5, 6, 7, 8};

	list<int> l(m, m + 8);

	list<int>::iterator it = l.begin();

	//it += 5; // illegal for lists

	it++;
	it--;
}

void test59() {
	// unsorted array passed to merge gives crash
	//int m1[] = {1, 2, 6, 4, 12, 32};

	int m1[] = {1, 2, 4, 6, 12, 32};
	int m2[] = {3, 5, 7, 9, 13, 15, 16, 34};

	list<int> l(m1, m1 + 6);

	vector<double> v(m2, m2 + 8);

	deque<double> d;

	merge(l.begin(), l.end(), v.begin(), v.end(), 
		inserter(d, d.begin()));

	for (auto it = d.begin(); it != d.end(); it++)
		cout << *it << " ";

	cout << endl;

	out << l << v;

	// gives compile error
	// list can't be sorted by sort algorithm
	// because it doesn't have operator+(iterator, int)
	// list::sort should be used instead
	//sort(l.begin(), l.end());
}

void test60() {
	using namespace TestBase;

	int m[] = {9, 8, 7 , 6, 5, 4, 3, 2, 1};

	vector<Base> v(m, m + 9);

	out << "-------------start sorting---------------";

	sort(v.begin(), v.end());

	out << "-------------end sorting-----------------";

	out << v;

	const Base b1 = 1, b2 = 2;

	out << (b2 < b1);

	out << b1;

	out << "||||||||||||||||||||||||||||||||";

	out << *v[2];

	*v[2] = 13;

	out << *v[2];

	out << "||||||||||||||||||||||||||||||||";

	out << v;
}

void test61() {
	vector<int> v(10, 5);

	copy(v.begin(), v.end(), 
		ostream_iterator<int>(cout, " "));

	cout << endl << 
		"Enter the sequence of numbers ended by Ctrl+Z" 
		<< endl;

	copy(istream_iterator<int>(cin), 
		istream_iterator<int>(),
		inserter(v, v.begin()));

	cout << endl;

	copy(v.begin(), v.end(), 
		ostream_iterator<int>(cout, " "));

	cout << endl;
}

void test62() {
	using namespace Test62;

	int m[] = {2, 8, 3, 9, 2, 4, 0, 5};

	sort(m, m + 8);

	copy(m, m + 8, 
		ostream_iterator<int>(cout, " "));

	cout << endl;

	sort(m, m + 8, RevComp());

	copy(m, m + 8, 
		ostream_iterator<int>(cout, " "));

	cout << endl;

	sort(m, m + 8);

	copy(m, m + 8, 
		ostream_iterator<int>(cout, " "));

	cout << endl;

	sort(m, m + 8, greater<int>());

	copy(m, m + 8, 
		ostream_iterator<int>(cout, " "));

	cout << endl;
}

void test63() {
	using namespace TestBase;

	int m[] = {2, 8, 3, 9, 2, 4, 0, 5};

	vector<int> v(m, m + 8);

	vector<int>::iterator endit = 
		remove(v.begin(), v.end(), 2);

	out << v;

	v.erase(endit, v.end());

	out << v;

	out << "[.......................]";

	{
		auto_ptr<Base> aptr(new Base);

		**aptr = 3;

		out << **aptr;

		out << *aptr.get();
	}

	out << "[.......................]";
}

void test64() {
	using namespace TestBase;
	using namespace Test64;

	int m[] = {1, 4, 2, 8, 3, 5};

	vector<Base> v(m, m + 6);

	//out << v[1] + v[2];

	out << "------------Accumulate algorithm--------";

	out << accumulate(v.begin(), v.end(), 
		Base());

	// do the same as previous
	out << accumulate(v.begin(), v.end(), 
		Base(), plus<Base>());

	out << "------------Accumulate algorithm--------";

	out << typeid(1 + v[2]).name();

	// this will be legal if
	// Base.operator+ returns non-const Base
	//v[1] + v[2] = 3;

	//int a, b;
	// this is illegal always
	// because (a + b) returns const int
	//(a + b) = 5;

	out << accumulate(m, m + 6, 0);

	// illegal, see func definition
	//int i = func();

	// 6 temporary objects of Base class are created
	// here to make cast from v[i] to int
	// next block fix this problem
	out << "___________________";
	out << count(v.begin(), v.end(), 8);
	out << "___________________";

	// there are no 6 type casts here
	// and respectively 6 creating of temporary objects
	out << "___________________";
	out << count(v.begin(), v.end(), Base(8));
	out << "___________________";
}

void test65() {
	using namespace Test65;

	int m[] = {1, 4, 2, 8, 3, 5};

	// outputs the quantity of elements of
	// m that is > 4
	out << count_if(m, m + 6, 
		bind2nd(greater<int>(), 4));

	// do the same thing as previous
	out << count_if(m, m + 6, Greater4());

	// outputs the quantity of elements of
	// m that is <= 4
	out << count_if(m, m + 6, 
		not1(bind2nd(greater<int>(), 4)));

	// outputs the quantity of elements of
	// m that is < 4
	out << count_if(m, m + 6, 
		bind1st(greater<int>(), 4));

	// outputs the quantity of elements of
	// m that is >= 4
	out << count_if(m, m + 6, 
		not1(bind1st(greater<int>(), 4)));

	// do the same as previous
	out << count_if(m, m + 6,
		bind2nd(greater_equal<int>(), 4));
}

void test66() {
	vector<int> v;

	// gives crash
	//v.insert(v.begin() + 5, 10);

	v.insert(v.begin(), 10);

	out << v;

	int m[] = {1, 2, 8, 3, 5, 2, 5, 1};

	set<int> s(m, m + 8);

	copy(s.begin(), s.end(), 
		ostream_iterator<int>(cout, " "));

	cout << endl;
}

void test67() {
	// create endl-like manipulator for class Out
	out << sep_;

	out << "@@@" << sep_ << "###";

	out << sep_;
}

void Test68() {
	using TestBase::Base;

	Base b1(1), b2(2);

	out << sep_;

	map<Base, const char*> m;

	out << sept;

	m[b1] = "text1";

	out << sep_;

	m[b2] = "text2";

	out << seps;

	for (map<Base, const char*>::iterator it = m.begin();
		it != m.end(); it++) {
			out << sepp << it->first << " " 
				<< it->second << sepp;
	}
}

void test69() {
	pair<int, double> p4(7, sqrt(7.0));

	out << p4.first << p4.second; 

	pair<int, double> p;

	out << p.first << p.second; 

	using TestBase::Base;

	Base b1(1), b2(2);

	// illegal, so bool is not l-value
	// but bool& is l-value
	// but both Base and Base& are l-values
	//(b1 < b2) = true;

	b1 < b2;

	// this works due to 
	// 	template<typename T>
	// 	bool operator>(const T &x, const T &y) {
	// 		return y < x;
	// 	}
	// is there standard implementation if this template?
	b1 > b2;

	typedef int intM[1000 * 1000 * 10];

	{
		//shared_ptr<intM> sp(new intM); // compile error
		//shared_ptr<int[10]> sp(new int[10]); // compile error

		// can be compiled but gives warning:
		// deleting array without using 
		// array form of delete operator
		//shared_ptr<intM> sp((intM*)new intM);
	}

	map<const char*, double> m;

	m["1.0"] = 1.0;

	m["2.0"] = 2.0;

	out << sepd;
}

void test70() {
	int m[] = {1, 2, 3, 4, 5};

	vector<int> v(m, m + 5);

	const vector<int> cv(m, m + 5);

	for (vector<int>::iterator it = v.begin();
		it != v.end(); it++) {
			out << *it;
	}

	// this is illegal
	//vector<int>::iterator it = cv.begin();

	for (vector<int>::const_iterator it = v.begin();
		it != v.end(); it++) {
			out << *it;
	}
}

// return the quantity of prime numbers
// that is less than maxN
int primes(int maxN) {
	vector<bool> s(maxN, true);

	int sqrtN = int(sqrt(double(maxN)) + 1);

	for (int i = 2; i < sqrtN; i++)
		if (s[i])
			for (int j = i * i; j < maxN; j += i)
				s[j] = false;

	return count(s.begin(), s.end(), true);
}

int primesCSharp(int maxN) {
	//vector<bool> s(maxN, true);

	// here is a memory leak
	// this is needed to compare with c# implementation
	bool *s = new bool[maxN];

	cout << "start" << endl;

	for (int i = 0; i < maxN; i++)
		s[i] = true;

	int sqrtN = int(sqrt(double(maxN)) + 1);

	for (int i = 2; i < sqrtN; i++)
		if (s[i])
			for (int j = i * i; j < maxN; j += i)
				s[j] = false;

	int count = 0;

	for (int i = 0; i < maxN; i++)
		if (s[i])
			count++;

	return count;
}

void test71() {
	vector<bool> vb(5, true);

	vb[2].flip();

	out << boolalpha << vb;

	vector<int> vi(10);

	// compile error
	// vector<int> doesn't provide flip method for
	// it's element
	// but vector<bool> does
	//vi[0].flip();

	using namespace Test71;

	Base<int, double> b;

	b.f1(1, 1.0);

	Base<bool, char> bb;

	bb.f2(true, 'Y');

	const int Size = 1024 * 1024 * 80;

	{
		vector<char> vc(Size); // needs 80 Mb
		vc;
	}

	{
		vector<bool> vb(Size); // needs 10 Mb
		vb;
	}

	out << "Start computation...";
	out << primes(1000000);
}

void test72() {
	using namespace Test72;

	{
		int m[] = {1, 2, 3, 4, 5};

		list<Base> l1(m + 1, m + 3), l2(m, m + 5);

		out << sep_;

		// there no copy constructor or assignment operator
		// calling here, just pointers are changed
		l2.splice(l2.end(), l1, l1.begin(), l1.end());

		out << sep_;

		out << l1 << l2;

		cout << "m[x] = " << *find_if(m, m + 5, 
			bind2nd(equal_to<int>(), 3)) << endl;
	}

	{
		int m[] = {3, 5, 3, 2, 7, 8, 3};

		list<int> l(m, m + 7);

		l.remove(3);

		out << l;
	}

	{
		int m[] = {3, 5, 3, 2, 7, 8, 3};

		list<Base> l(m, m + 7);

		out << sepp;
		l.remove(3);
		out << sepp;

		out << l;
	}

	{
		//unsorted array gives crash
		//int m1[] = {1, 2, 6, 4, 12, 32};

		int m1[] = {1, 2, 4, 6, 12, 32};
		int m2[] = {3, 5, 7, 9, 13, 15, 16, 34};

		list<int> l1(m1, m1 + 6);
		list<int> l2(m2, m2 + 8);

		out << l1 << l2;

		l2.merge(l1);

		out << l1 << l2; // l1 is empty here
	}
}