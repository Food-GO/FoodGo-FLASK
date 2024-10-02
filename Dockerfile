# Python 3.9 slim 이미지 사용
FROM --platform=linux/amd64 python:3.9-slim

# 심볼릭 링크 설정 (python3 -> python), 이미 존재할 경우 강제 덮어쓰기
RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python

# 시스템 패키지 업데이트 및 OpenGL 관련 라이브러리 설치
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 복사
COPY requirements.txt requirements.txt

# 패키지 설치 (pandas 포함)
RUN pip install --no-cache-dir --default-timeout=1000 --trusted-host pypi.python.org -r requirements.txt pandas

# YOLOv5 리포지토리 및 모델 가중치 복사
COPY yolov5 /app/yolov5
COPY best10_01.pt /app/best10_01.pt

# Flask 애플리케이션 코드 복사
COPY . /app

# Flask 앱 실행
CMD ["python", "app.py"]
