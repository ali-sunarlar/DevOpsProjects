import time
import datetime

def main():
    while True:
        current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"WebJob çalışıyor: {current_time}")
        
        # 1 dakika bekle
        time.sleep(60)

if __name__ == "__main__":
    main()