# NGUYEN-HOANG-TRIEU---TymeX-Internship-Program-2024---Mobile-Intern--iOS-Android----Online-Test
 
- Cấu trúc của ứng dụng:
	- Thư mục chính: lib/
	- Thư mục con:
		- controller: Chứa file xử lí kết nối và trả về dữ liệu
		- model: Chứa file khởi tạo đối tượng để biểu diễn dữ liệu
		- view: Chứa file khởi tạo giao diện với cấu trúc như sau
			- MainView.dart (Giao diện tổng thể)
				- CurrencyConverter.dart (Phần chuyển đổi tiền tệ giữa hai nước)
					- CountryFrame.dart (Phần hiển thị cờ và currency của hai nước)
					- ListCurrency.dart (Hiển thị danh sách tiền tệ khác nhau để người dùng lựa chọn)
				- ListCurrencyChoosen.dart (Hiện thị danh sách các nước được chọn để chuyển đổi)
		- provider: Chứa file khởi tạo đối tượng xử dụng cho cả hệ thống (kiểm tra Internet)
		- utils: Chứa file khởi tạo các biến sử dụng cho cả ứng dụng (Màu sắc, text, đường dẫn, …)
		- unittest: Chứa file unni test (kiểm thử hàm chuyển đổi tiền tệ)

- Các bước để xây dựng và chạy ứng dụng: 
	- Cài đặt Flutter SDK.
 	- Cài đặt Android Studio.
	- Tạo một dự án Flutter mới.
	- Mở dự án trong IDE.
	- Kết nối thiết bị hoặc chạy thiết bị ảo.
	- Chạy ứng dụng.
	- Phát triển và kiểm thử ứng dụng.
- Lưu ý: 
- Service cung cấp API từ exchangerate giới hạn về số request (100 request / tháng)
{
    "success": true,
    "timestamp": 1730601842,
    "base": "EUR",
    "date": "2024-11-03",
    "rates": {
        "AED": 3.996561,
        "AFN": 72.725294,
        "ALL": 98.323637,
        "AMD": 420.572784,
	….
 }
- Sevice chỉ cung cấp các tỉ giá các nước dựa trên đồng EUR (những service nâng cao hơn phải trả phí để sử dụng)
=> Ứng dụng sử dụng công thức chuyển đổi các giá tiền giữa các nước khác dựa trên:
	VD: 1 EURO = 27.496 VND
	        1 EURO = 1,09 USD
	=> 27.496 VND = 1,09 USD	
		=> 1 VND = 1,09 / 27.496 hoặc 1 USD = 27.496 / 1,09
- Đường dẫn demo ứng dụng: https://drive.google.com/file/d/13HvNwmPtl9ih5cN4RnvH-B__TZ1PfN3v/view?usp=sharing
		
 
