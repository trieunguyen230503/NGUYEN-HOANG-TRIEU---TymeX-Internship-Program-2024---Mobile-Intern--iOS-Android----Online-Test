using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Challenge2._1
{
    public class Sort
    {

        public Product[] MergeSort(Product[] products, Comparison<Product> comparison, int sortType)
        {
            if (products.Length <= 1) { return products; }

            int mid = products.Length / 2;

            Product[] left = new Product[mid];
            Product[] right = new Product[products.Length - mid];

            for (int i = 0; i < left.Length; i++)
                left[i] = products[i];
            for (int i = 0; i < right.Length; i++)
                right[i] = products[i + mid];

            left = MergeSort(left, comparison, sortType);
            right = MergeSort(right, comparison, sortType);

            return Merge(products, left, right, comparison, sortType);
        }

        private Product[] Merge(Product[] products, Product[] left, Product[] right, Comparison<Product> comparison, int sortType)
        {
            int i = 0, j = 0, k = 0;

            while (i < left.Length && j < right.Length)
                if (sortType == 1) // descending
                    if (comparison(left[i], right[j]) >= 0)
                        products[k++] = left[i++];
                    else
                        products[k++] = right[j++];
                else // ascending
                {
                    if (comparison(left[i], right[j]) <= 0)
                        products[k++] = left[i++];
                    else
                        products[k++] = right[j++];
                }

            while (i < left.Length) products[k++] = left[i++];
            while (j < right.Length) products[k++] = right[j++];

            return products;
        }
    }
}
