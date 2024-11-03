double convert(double amount, double rate1, double rate2) {
  if(amount <= 0 || rate1 <= 0 || rate2 <= 0) return -1;
  return (amount * rate2) / rate1;
}