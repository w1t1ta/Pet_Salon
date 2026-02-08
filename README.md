# Pet Salon Manager

## การทำงานของระบบ (Project Demo)

### 1. การเข้าสู่ระบบและเลือกบทบาท (Login & Role Selection)
1. เมื่อเปิดแอปพลิเคชัน ผู้ใช้จะพบกับหน้าจอสำหรับเลือกบทบาทการใช้งาน ซึ่งแบ่งออกเป็น 2 ส่วนหลักคือ "ลูกค้า (Customer)" และ "เจ้าของร้าน (Admin)" เพื่อจำลองการทำงานที่แตกต่างกันในแอปเดียว
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/a5d5d55e-6466-475e-8569-734806bf8d35" />

### 2. หน้าหลักและการจองคิว (User Interface)
1. **การเลือกบริการ:** เมื่อเข้าสู่ระบบในฐานะลูกค้า จะพบกับรายการบริการทั้งหมดของทางร้าน (Services) ซึ่งดึงข้อมูลมาจากระบบ API ลูกค้าสามารถดูรายละเอียดและเลือกบริการที่ต้องการได้
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/62fdaae3-7c6a-4e3c-97ff-7e7f6a78ae62" />

2. **การทำรายการจอง:** ในหน้าจองคิว (Booking) ลูกค้าสามารถกรอกข้อมูลชื่อสัตว์เลี้ยง เลือกประเภท (สุนัข/แมว) และเลือกบริการผ่าน Dropdown ที่เชื่อมโยงกับฐานข้อมูล รวมถึงเลือกวันที่และเวลาที่ต้องการนัดหมาย
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/f5e0db50-bb2f-4edd-ba1e-c0fa37df2512" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/4f24bdd2-01a6-46d6-b7e8-05ec3f3f1859" />

### 3. การจัดการสถานะและการตรวจสอบ (History & Tracking)
1. ระบบจะแสดงรายการจองทั้งหมดในหน้า "ประวัติการจอง" โดยมีการแบ่งสถานะชัดเจนด้วยสี (สีเหลือง: รออนุมัติ, สีเขียว: ยืนยันแล้ว, สีเทา: เสร็จสิ้น)

2. **สำหรับลูกค้า:** สามารถกดยกเลิกการจองได้หากสถานะยังเป็น "รออนุมัติ"
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/c0490e3f-c605-4112-a816-749799dc67a8" />

3. **สำหรับเจ้าของร้าน:** สามารถกดเปลี่ยนสถานะได้ เช่น กด "รับงาน (Confirm)" เมื่อต้องการยืนยันคิว หรือกด "เสร็จสิ้น (Complete)" เมื่อให้บริการเสร็จแล้ว
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/d34c7143-0985-4b37-96f3-581cb5064e1a" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/5ddbcdbc-651e-4b27-9f4f-17611b98e87e" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/545a3a62-7ac5-4908-9e59-1ac2c4245fe5" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/669df624-1543-497b-aea5-892e569eb555" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/51540e6a-46f5-4046-a99e-b1711f1eb015" />

### 4. แดชบอร์ดสรุปผล (Admin Dashboard)
สำหรับเจ้าของร้าน ระบบจะมีหน้า Dashboard เพื่อสรุปภาพรวมของกิจการ โดยมีการคำนวณข้อมูลแบบ Real-time ได้แก่:
- รายได้รวมทั้งหมด (Total Income)
- จำนวนคิวที่รอการอนุมัติ (Pending)
- จำนวนงานที่ให้บริการเสร็จสิ้นแล้ว (Completed)
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/e56c851e-42aa-4272-a199-cc761899d7c5" />
<img width="190.5" height="404" alt="Image" src="https://github.com/user-attachments/assets/30d69281-3bce-4dc8-8cea-84c92ca8b4c7" />

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
