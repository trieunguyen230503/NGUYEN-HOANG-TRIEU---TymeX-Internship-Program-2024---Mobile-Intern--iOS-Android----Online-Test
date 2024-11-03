using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Challenge2._2
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] array1 = { 3, 7, 1, 2, 8, 4, 5 };
            int n1 = 8;
            Console.WriteLine("Missing number of array 1 is: {0}",
                FindMissingNumber(array1, n1));

            int[] array2 = { 1, 2, 3, 5 };
            int n2 = 5;
            Console.WriteLine("Missing number of array 2 is: {0}",
                FindMissingNumber(array2, n2));
        }

        public static int FindMissingNumber(int[] a, int n)
        {
            // Công thức tính tổng của một cấp số cộng từ 1 đến n trên lí thuyết
            int expectedSum = n * (n + 1) / 2;

            //Công thức tính tổng thực tế
            //Cách 1:
            int actualSum = a.Sum();

            //Cách 2:
            //int actualSum = 0;
            //for (int i = 0; i < a.Length; i++)
            //    actualSum += a[i];

            //Do đề bài chỉ yêu cầu tìm đúng DUY NHẤT 1 số còn thiếu
            //=> Ta lấy hiệu của tổng số mong đợi và tổng số thực tế => số còn thiếu
            return expectedSum - actualSum;
        }
    }
}
