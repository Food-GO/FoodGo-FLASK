# Python 3.9 이미지 사용
FROM python:3.9-slim

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# YOLOv5 리포지토리 및 모델 가중치 복사
COPY yolov5 /app/yolov5
COPY best10_01.pt /app/best10_01.pt

# Flask 애플리케이션 코드 복사
COPY . /app

# Flask 앱 실행
CMD ["python", "app.py"]
