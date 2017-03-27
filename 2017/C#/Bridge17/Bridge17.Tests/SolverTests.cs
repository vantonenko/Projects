using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Bridge17.Tests
{
    [TestClass]
    public class SolverTests
    {
        [TestMethod]
        public void TestIsValidMovePositiveCase()
        {
            bool isValidMove = Solver.IsValidMove(new State
            {
                Left = new List<int> {10, 5, 2},
                Right = new List<int>(),
                IsFlashAtLeft = true
            }, new List<int> {10, 5});

            Assert.IsTrue(isValidMove);
        }

        [TestMethod]
        public void TestIsValidMoveNegativeCase()
        {
            bool isValidMove = Solver.IsValidMove(new State
            {
                Left = new List<int> {10, 5, 2},
                Right = new List<int>(),
                IsFlashAtLeft = false
            }, new List<int> {10, 5});

            Assert.IsFalse(isValidMove);
        }

        [TestMethod]
        public void TestIsValidMoveNegativeSophisticatedCase()
        {
            bool isValidMove = Solver.IsValidMove(new State
            {
                Left = new List<int> {10, 5, 2},
                Right = new List<int>(),
                IsFlashAtLeft = true
            }, new List<int> {5, 1});

            Assert.IsFalse(isValidMove);
        }

        [TestMethod]
        public void TestSolver()
        {
            
        }
    }
}
