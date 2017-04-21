// smartPtr.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <memory>
#include <iostream>
#include <sstream>

#include <vector>

#include <string>

using namespace std;

class TestElem;

typedef shared_ptr<TestElem> ShTestElem;

class TestElem {
	static int gid;
	int _id;

public:
	TestElem(): _id(gid++) {
		cout << name() << " TestElem()" << endl;
	}

	TestElem(const TestElem& t): _id(gid++) {
		cout << name() << " TestElem(const TestElem&)" << endl;
	}

	TestElem& operator=(const TestElem&) {
		cout << name() << " operator=(const TestElem&)" << endl;
	}

	~TestElem() {
		cout << name() << " ~TestElem()" << endl;
	}

private:
	string name() {
		stringstream ss;

		ss << "Instance #" << _id;

		return ss.str();
	}
};

int TestElem::gid = 0;

class Test {
	vector<ShTestElem> vect;

public:
	Test() {
		for (int i = 0; i < 100; i++)
			addElem();

		cout << "Init is finished" << endl;
	}
	
	void manipulate() {
		cout << "Manipulate is started" << endl;

		for (int i = 0; i < 100; i++)
			randomAssign();

		cout << "Manipulate is finished" << endl;
	}

	~Test() {
		cout << "Destruction" << endl;
	}
private:
	void addElem() {
		ShTestElem e(new TestElem());
		vect.push_back(e);
	}

	void randomAssign() {
		int source = rand() % vect.size();
		int dest = rand() % vect.size();

		vect[dest] = vect[source]; 
	}
};

int _tmain(int argc, _TCHAR* argv[])
{
	Test test;

	test.manipulate();

	return 0;
}