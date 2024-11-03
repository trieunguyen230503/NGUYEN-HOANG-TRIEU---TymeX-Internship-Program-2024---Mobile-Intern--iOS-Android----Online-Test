using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Challenge2._1
{
    public class MangeProduct
    {
        public List<Product> products;
        Sort sortAlgorithm = new Sort();

        public MangeProduct(string filepath)
        {
            products = new List<Product>();

            using (StreamReader streamReader = new StreamReader(filepath))
            {
                string line;
                while ((line = streamReader.ReadLine()) != null)
                {
                    string[] propertyOfProduct = line.Split(' ');
                    products.Add(new Product(propertyOfProduct[0], double.Parse(propertyOfProduct[1]),
                        int.Parse(propertyOfProduct[2])));
                }
            }

        }

        public double TotalInventoryValue()
        {
            //Option 1
            double totalInventory = 0;
            for (int i = 0; i < products.Count; i++)
                totalInventory += products[i].Price * products[i].Quantity;

            //Option 2
            //return products.Sum(product => product.Price * product.Quantity);

            return totalInventory;
        }

        public string FindMostExpensiveProduct()
        {
            Product productTemp = sortAlgorithm.MergeSort(products.ToArray(),
                (p1, p2) => p1.Price.CompareTo(p2.Price), 1)[0];

            DisplayProduct(new List<Product> { productTemp }.ToArray());
            return productTemp.Name;
        }

        public bool IsProductInStock(string nameInput)
        {
            //Option 1
            for (int i = 0; i < products.Count; i++)
            {
                if (products[i].Name.ToLower() == nameInput.Trim().ToLower())
                {
                    DisplayProduct(new List<Product> { products[i] }.ToArray());
                    return true;
                }
            }
            return false;

            //Option 2
            //return products.Any(product => product.Name == nameInput.Trim());
        }

        public Product[] SortProducts(int dataSort, int sortType)
        {
            if (dataSort == 1) return sortAlgorithm.MergeSort(products.ToArray(),
                (p1, p2) => p1.Price.CompareTo(p2.Price), sortType);

            else if (dataSort == 2) return sortAlgorithm.MergeSort(products.ToArray(),
                (p1, p2) => p1.Quantity.CompareTo(p2.Quantity), sortType);

            else return sortAlgorithm.MergeSort(products.ToArray(), (
                p1, p2) => p1.Name.CompareTo(p2.Name), sortType);
        }

        public void DisplayProduct(Product[] productTempList)
        {
            Console.WriteLine("{0,-25}|{1,10}|{2,13}", "Name", "Price", "Quantity|");
            Console.WriteLine(new string('-', 50));

            for (int i = 0; i < productTempList.Length; i++)
            {
                Console.WriteLine("{0,-25}|{1,10:F2}|{2,12}|", productTempList[i].Name,
                    productTempList[i].Price, productTempList[i].Quantity);
            }
            Console.WriteLine();

        }
    }
}
