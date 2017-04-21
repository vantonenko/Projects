// PrimeNumbers.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include <iostream>

#include <vector>
#include <bitset>
#include <algorithm>

#include "windows.h"

using namespace std;

const int primesForBitset = 100000000;

void primesWithBitset(int n = primesForBitset)
{
	bitset<primesForBitset + 1> *range = new bitset<primesForBitset + 1>();

	range->set();

	cout << "Memory is allocated" << endl;

	int i = 2;

	while (i * i <= n)
	{
		if (range->test(i))
		{
			int j = i * i;

			while (j <= n)
			{
				range->reset(j);
				j += i;
			}
		}

		i += 1;
	}

	/*
	cout << "Prime numbers from the range 1.." << n << ":" << endl;
	
	for (int i = 0; i < n; i++)
	 	if (range->test(i))
	 		cout << i << endl;
	//*/

	cout << "Done..." << endl;

	cout << "The quantity of prime numbers in the range 1.." << 
		n << " is: " << range->count() << endl;
}

void primesWithVector(int n) 
{
	vector<bool> range(n + 1, true);

	int i = 2;

	while (i * i <= n)
	{
		if (range[i])
		{
			int j = i * i;

			while (j <= n)
			{
				range[j] = false;
				j += i;
			}
		}

		i += 1;
	}

// 	cout << "Prime numbers from the range 1.." << n << ":" << endl;
// 
// 	for (int i = 0; i < n; i++)
// 		if (range[i])
// 			cout << i << endl;

	cout << "Done..." << endl;

	cout << "The quantity of prime numbers in the range 1.." << 
		n << " is: " << count(range.begin(), range.end(), true) << endl;
}

void primesUI()
{
	do 
	{
		cout << "Enter the size of the range or 0 to quit: ";

		int n;

		cin >> n;

		if (n == 0)
			break;
		else
			primesWithVector(n);
	}
	while (true);
}

int _tmain(int argc, _TCHAR* argv[])
{
// 	cout << "Start" << endl;
// 
// 	int start = GetTickCount();
// 
// 	double d = 0;
// 
// 	while (d < 1000 * 1000 * 1000.0)
// 	{
// 		d += 1.0;
// 	}
// 
// 	cout << GetTickCount() - start << endl;

	//primesUI();
	primesWithBitset();

	int x;
	cin >> x;

	return 0;
}

