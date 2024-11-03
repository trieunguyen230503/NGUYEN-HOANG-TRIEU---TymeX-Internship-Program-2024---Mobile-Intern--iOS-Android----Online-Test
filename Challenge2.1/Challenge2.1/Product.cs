using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Challenge2._1
{
    public class Product
    {
        private string name;
        private double price;
        private int quantity;

        public Product(string name, double price, int quantity)
        {
            this.name = name;
            this.price = price;
            this.quantity = quantity;
        }

        public string Name
        {
            get { return name; }
        }

        public double Price
        {
            get { return price; }
        }

        public int Quantity
        {
            get { return quantity; }
        }
    }
}
