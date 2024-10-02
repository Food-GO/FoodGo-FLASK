from flask import Flask, request, jsonify
import torch
from PIL import Image
import io

# Flask 앱 생성
app = Flask(__name__)

model_path = '/app/best10_01.pt'  # Docker 컨테이너 내의 경로
yolov5_repo_path = '/app/yolov5'  # Docker 컨테이너 내의 YOLOv5 리포지토리 경로
model = torch.hub.load(yolov5_repo_path, 'custom', path=model_path, source='local')

# 라우트 설정
@app.route('/detect', methods=['POST'])
def detect():
    # 클라이언트에서 이미지 파일 수신
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    image_file = request.files['image']
    image_bytes = image_file.read()

    # 이미지 PIL 형식으로 변환
    img = Image.open(io.BytesIO(image_bytes))

    # YOLO 모델로 예측
    results = model(img)

    # YOLO 모델의 전체 결과를 텍스트로 출력
    print("\n=== YOLOv5 Prediction Results (Raw) ===")
    results.print()  # YOLO 결과를 텍스트 형식으로 출력

    # YOLO 모델 결과 객체 그대로 JSON으로 변환하여 반환
    results_dict = results.pandas().xyxy[0].to_dict(orient="records")  # JSON 변환 가능한 객체로 변환

    # 결과를 JSON으로 반환
    return jsonify({
        'raw_results': results_dict,  # xyxy 좌표 가공 없이 그대로 반환
    })

# 앱 실행
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
