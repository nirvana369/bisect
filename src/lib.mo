/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.mo
* Description       : Bisect Library in Motoko
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 19/06/2025		nirvana369 		implement
******************************************************************/

import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Buffer "mo:base/Buffer";


module Bisect {

  // --- BISSECT RIGHT ---
  // Tương đương bisect.bisect hoặc bisect.bisect_right trong Python

  /**
   * Tìm chỉ số chèn bên phải nhất cho x trong mảng đã sắp xếp arr.
   * Yêu cầu: Kiểu T phải hỗ trợ toán tử so sánh '<'.
   * @param arr Mảng [var T] đã được sắp xếp.
   * @param x Giá trị kiểu T cần tìm vị trí chèn.
   * @param lo_opt Chỉ số bắt đầu tìm kiếm (tùy chọn, mặc định 0).
   * @param hi_opt Chỉ số kết thúc tìm kiếm (tùy chọn, mặc định kích thước mảng).
   * @return Chỉ số Nat thích hợp để chèn x.
   */
   public func bisect_right<T>(arr : [T], x : T, lo_opt : ?Nat, hi_opt : ?Nat, fcmp : (T, T) -> Order.Order) : Nat {
    let size = arr.size();
    // Xử lý giá trị mặc định cho lo và hi
    var lo = Option.get(lo_opt, 0);
    // Đảm bảo hi không vượt quá kích thước mảng
    var hi = Nat.min(Option.get(hi_opt, size), size);

    // Kiểm tra cơ bản (tùy chọn)
    // if (lo < 0) { throw Error.reject("lo must be non-negative"); }; // Nat luôn không âm
    if (lo > hi) {
        // Có thể xử lý khác, nhưng trả về lo là hợp lý theo logic vòng lặp
        return lo;
    };

    while (lo < hi) {
        // Phép chia Nat tự động làm tròn xuống
        let mid = lo + (hi - lo) / 2;
        // Yêu cầu T hỗ trợ toán tử '<'
        if (fcmp(x, arr[mid]) == #less) {//(x < arr[mid]) {
            // Vị trí chèn phải ở nửa trái (bao gồm cả mid)
            hi := mid;
        } else {
            // Vị trí chèn phải ở nửa phải (bắt đầu từ mid + 1)
            lo := mid + 1;
        };
    };
    return lo;
  };

  // --- INSORT RIGHT ---
  // Tương đương bisect.insort hoặc bisect.insort_right trong Python

  /**
   * Chèn x vào mảng đã sắp xếp arr tại vị trí bên phải nhất.
   * Hàm này sẽ gán lại biến arr để trỏ đến mảng mới đã được chèn.
   * Yêu cầu: Kiểu T phải hỗ trợ toán tử so sánh '<' và gán ':='.
   * @param arr Mảng [var T] đã được sắp xếp (sẽ được cập nhật).
   * @param x Giá trị kiểu T cần chèn.
   * @param lo_opt Chỉ số bắt đầu tìm kiếm vị trí (tùy chọn).
   * @param hi_opt Chỉ số kết thúc tìm kiếm vị trí (tùy chọn).
   * @return () - Unit, vì hàm thay đổi trạng thái.
   */
    public func insort_right<T>(arr : [T], x : T, lo_opt : ?Nat, hi_opt : ?Nat, fcmp : (T, T) -> Order.Order) : ([T]) {
      let index = bisect_right<T>(arr, x, lo_opt, hi_opt, fcmp);

      // Workaround: Tạo mảng mới bằng cách nối x vào cuối
      // Gán lại con trỏ arr để trỏ tới mảng mới này
      let arrTmp = Buffer.fromArray<T>(arr);
      arrTmp.insert(index, x);
      Buffer.toArray<T>(arrTmp);
   };


  // --- BISSECT LEFT --- (Tương tự nhưng với logic so sánh khác)
  // Tương đương bisect.bisect_left trong Python

  /**
   * Tìm chỉ số chèn bên trái nhất cho x trong mảng đã sắp xếp arr.
   * Yêu cầu: Kiểu T phải hỗ trợ toán tử so sánh '<'.
   */
   public func bisect_left<T>(arr : [T], x : T, lo_opt : ?Nat, hi_opt : ?Nat, fcmp : (T, T) -> Order.Order) : Nat {
    let size = Array.size(arr);
    var lo = Option.get(lo_opt, 0);
    var hi = Nat.min(Option.get(hi_opt, size), size);

    if (lo > hi) { return lo; };

    while (lo < hi) {
      let mid = lo + (hi - lo) / 2;
      // Logic so sánh khác cho bisect_left
      if (fcmp(arr[mid], x) == #less) {
        // Nếu phần tử giữa nhỏ hơn x, vị trí chèn phải ở bên phải (mid + 1)
        lo := mid + 1;
      } else {
        // Nếu phần tử giữa lớn hơn hoặc bằng x, vị trí chèn có thể là mid hoặc bên trái
        hi := mid;
      };
    };
    return lo;
  };

  // --- INSORT LEFT --- (Tương tự insort_right nhưng dùng bisect_left)
  // Tương đương bisect.insort_left trong Python

  /**
   * Chèn x vào mảng đã sắp xếp arr tại vị trí bên trái nhất.
   * Hàm này sẽ gán lại biến arr để trỏ đến mảng mới đã được chèn.
   * Yêu cầu: Kiểu T phải hỗ trợ toán tử so sánh '<' và gán ':='.
   */
   public func insort_left<T>(arr : [T], x : T, lo_opt : ?Nat, hi_opt : ?Nat, fcmp : (T, T) -> Order.Order) : ([T]) {
        // Sử dụng bisect_left để tìm chỉ số
        let index = bisect_left<T>(arr, x, lo_opt, hi_opt, fcmp);

        let arrTmp = Buffer.fromArray<T>(arr);
        arrTmp.insert(index, x); 
        Buffer.toArray<T>(arrTmp);
   };
}