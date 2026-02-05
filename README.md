# Pet Salon Manager

## ตัวอย่างการทำงานของระบบ (Project Demo)

### 1. การเข้าสู่ระบบและเลือกบทบาท (Login & Role Selection)
1. เมื่อเปิดแอปพลิเคชัน ผู้ใช้จะพบกับหน้าจอสำหรับเลือกบทบาทการใช้งาน ซึ่งแบ่งออกเป็น 2 ส่วนหลักคือ "ลูกค้า (Customer)" และ "เจ้าของร้าน (Admin)" เพื่อจำลองการทำงานที่แตกต่างกันในแอปเดียว
![Login Screen](https://via.placeholder.com/800x400?text=Login+Screen+Screenshot)
<br><br>

### 2. หน้าหลักและการจองคิว (User Interface)
1. **การเลือกบริการ:** เมื่อเข้าสู่ระบบในฐานะลูกค้า จะพบกับรายการบริการทั้งหมดของทางร้าน (Services) ซึ่งดึงข้อมูลมาจากระบบ API ลูกค้าสามารถดูรายละเอียดและเลือกบริการที่ต้องการได้
![Home Screen](https://via.placeholder.com/800x400?text=Home+Services+Screenshot)
<br><br>
2. **การทำรายการจอง:** ในหน้าจองคิว (Booking) ลูกค้าสามารถกรอกข้อมูลชื่อสัตว์เลี้ยง เลือกประเภท (สุนัข/แมว) และเลือกบริการผ่าน Dropdown ที่เชื่อมโยงกับฐานข้อมูล รวมถึงเลือกวันที่และเวลาที่ต้องการนัดหมาย
![Booking Screen](https://via.placeholder.com/800x400?text=Booking+Form+Screenshot)

### 3. การจัดการสถานะและการตรวจสอบ (History & Tracking)
1. ระบบจะแสดงรายการจองทั้งหมดในหน้า "ประวัติการจอง" โดยมีการแบ่งสถานะชัดเจนด้วยสี (สีเหลือง: รออนุมัติ, สีเขียว: ยืนยันแล้ว, สีเทา: เสร็จสิ้น)
2. **สำหรับลูกค้า:** สามารถกดยกเลิกการจองได้หากสถานะยังเป็น "รออนุมัติ"
3. **สำหรับเจ้าของร้าน:** สามารถกดเปลี่ยนสถานะได้ เช่น กด "รับงาน (Confirm)" เมื่อต้องการยืนยันคิว หรือกด "เสร็จสิ้น (Complete)" เมื่อให้บริการเสร็จแล้ว
![History Screen](https://via.placeholder.com/800x400?text=History+Tracking+Screenshot)

### 4. แดชบอร์ดสรุปผล (Admin Dashboard)
สำหรับเจ้าของร้าน ระบบจะมีหน้า Dashboard เพื่อสรุปภาพรวมของกิจการ โดยมีการคำนวณข้อมูลแบบ Real-time ได้แก่:
- รายได้รวมทั้งหมด (Total Income)
- จำนวนคิวที่รอการอนุมัติ (Pending)
- จำนวนงานที่ให้บริการเสร็จสิ้นแล้ว (Completed)
![Dashboard Screen](https://via.placeholder.com/800x400?text=Admin+Dashboard+Screenshot)

## โครงสร้างไฟล์และการทำงานที่สำคัญ
```text
PET_SALON_MANAGER/
│
├── lib/                           # ส่วนโค้ดหลักของ Flutter Application
│   ├── main.dart                  # จุดเริ่มต้นแอปและส่วนจัดการ API (Controller)
│   ├── login_screen.dart          # หน้าจอเลือกบทบาท (User/Admin)
│   ├── main_screen.dart           # ตัวควบคุม Navigation Bar
│   ├── home_screen.dart           # หน้าแสดงรายการบริการ
│   ├── booking_screen.dart        # หน้าฟอร์มจองคิว
│   ├── history_screen.dart        # หน้าจัดการสถานะและประวัติ
│   └── dashboard_screen.dart      # หน้าสรุปยอดรายได้ (Admin Only)
│
├── pubspec.yaml                   # ไฟล์ระบุ Dependencies (http, intl, etc.)
└── README.md                      # คู่มือการติดตั้งและใช้งานระบบ
