using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Challenge2._1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine();
            string filePath = "Data/Product.txt";
            MangeProduct mangeProduct = new MangeProduct(filePath);
            int choice;
            do
            {
                Console.Clear();
                choice = Menu();
                switch (choice)
                {
                    case 0:
                        {
                            Console.WriteLine("See you late");
                            break;
                        }
                    case 1:
                        {
                            mangeProduct.DisplayProduct(mangeProduct.products.ToArray());
                            Console.WriteLine("Total Inventory Value: {0:F2}",
                                mangeProduct.TotalInventoryValue());
                            Console.WriteLine();
                            break;
                        }
                    case 2:
                        {
                            Console.WriteLine("The most expensive product is: {0}",
                                mangeProduct.FindMostExpensiveProduct());
                            break;
                        }
                    case 3:
                        {
                            Console.Write("Please enter product name: ");
                            string productName = Console.ReadLine();
                            Console.WriteLine();
                            Console.WriteLine(mangeProduct.IsProductInStock(productName));

                            break;
                        }
                    case 4:
                        {
                            Console.WriteLine("Which kind of Data?");
                            Console.WriteLine("   1. Price   2. Quantity   3. Name");
                            Console.Write("   Choose: ");
                            int dataSort = int.Parse(Console.ReadLine());
                            Console.WriteLine();

                            Console.WriteLine("Which kind of Sort?");
                            Console.WriteLine("   1. Descending   2. Ascending");
                            Console.Write("   Choose: ");
                            int sortType = int.Parse(Console.ReadLine());
                            Console.WriteLine();

                            mangeProduct.DisplayProduct(
                                mangeProduct.SortProducts(dataSort, sortType));
                            break;
                        }
                    default:
                        Console.WriteLine("Please choose the numer from 1 to 4");
                        break;

                }
                Console.ReadKey();
            } while (choice != 0);
        }

        static int Menu()
        {
            string choice;
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine(new string('-', 30) + "  PRODUCT MANAGER  " + new string('-', 30));
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine("      1. Calculate the total inventory value");
            Console.WriteLine("      2. Find the most expensive product");
            Console.WriteLine("      3. Check product in stock");
            Console.WriteLine("      4. Sort Product");
            Console.WriteLine("      0. Exit");
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine(new string('-', 80));
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Choose : ");


            choice = Console.ReadLine();
            Console.WriteLine();
            if (int.TryParse(choice, out int Result))
            {
                return int.Parse(choice);
            }
            else
                return int.MaxValue;
        }
    }
}
