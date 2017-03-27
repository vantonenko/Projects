using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Bridge17.Tests
{
    [TestClass]
    public class EnumerableExtensionsTests
    {
        [TestMethod]
        public void TestNormalCase()
        {
            TestCase(new List<int> {10, 5, 2, 1}, "10,5;10,2;10,1;5,2;5,1;2,1", 6);
        }

        [TestMethod]
        public void TestSinglePairCase()
        {
            TestCase(new List<int> {10, 5}, "10,5", 1);
        }

        [TestMethod]
        public void TestSingularCase()
        {
            TestCase(new List<int>(), "", 0);
        }

        private static void TestCase(IEnumerable<int> list, string expected, int count)
        {
            List<IReadOnlyList<int>> allPairs = list.GetAllPairs().ToList();

            string actual = string.Join(";", allPairs.Select(p => string.Join(",", p)));

            Assert.AreEqual(actual, expected);
            Assert.AreEqual(allPairs.Count, count);
        }
    }
}
